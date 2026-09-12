extends "res://Core/Chambers/CombatChamberBase.gd"

## Hushiro combat-chamber rules layer.
##
## The shared CombatChamberBase owns general gate/chamber plumbing. Hushiro-specific
## encounter selection, pressure coordination, and current reward compatibility live
## here so the region follows its approved authored encounter model.

const HUSHIRO_CATALOG = preload("res://Utility/HushiroEncounterCatalog.gd")

# Legacy role limits remain as compatibility infrastructure for non-migrated actors.
# Combat V2 standard enemies schedule damaging impact windows through PressureDirectorV2;
# Phase 7 therefore allows authored close-pressure groups to occupy more frontline space
# without raising the legacy one-melee-turn cap or stacking severe impacts.
const HUSHIRO_MELEE_COOLDOWN: float = 0.95
const HUSHIRO_ADVANCE_COOLDOWN: float = 0.70
const HUSHIRO_RANGED_COOLDOWN: float = 1.60
const HUSHIRO_DOG_LUNGE_COOLDOWN: float = 3.00
const HUSHIRO_GRANT_GAP: float = 0.40
const HUSHIRO_TURNOVER_DELAY: float = 0.45

# These are the canonical migrated families whose authored combat role can legitimately
# occupy the player's close-pressure ring. Archers and Bilemass remain ranged/spatial
# pressure and therefore must not inflate the frontline budget merely because a wave is
# populous. `advance_move` remains a separate legacy movement gate used chiefly by
# Swordsmen/Hounds; this Phase 7 slice does not globally increase it for mixed rooms.
const PHASE7_FRONTLINE_PRESSURE_TYPES: Array[String] = [
	"swordsman",
	"hollow",
	"hound",
	"warden",
]

const HUSHIRO_COMBAT_PAYOUTS: Dictionary = {
	"gold": 60,
	"mist": 20,
	"scroll": 1,
}


func _ready() -> void:
	# Keep telemetry and runtime paths aligned with the canonical Chamber vocabulary,
	# even if this scene is reached through a compatibility wrapper.
	name = "CombatChamber"

	# The inherited ready path still owns bounds, gates and encounter startup.
	# Its virtual calls dispatch to the Hushiro overrides below.
	super._ready()
	print("[HushiroCombatChamber] Authored encounter coordination active")


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if area_id != 1:
		return super._pick_encounter_for_area(area_id)

	# GameFlow's route index is the authoritative counted-chamber position. RunData.depth
	# is retained for run summaries but legacy direct choice traversal can update it one
	# callback later, which must not change encounter minimum-chamber eligibility.
	var chamber_number: int = maxi(1, int(GameFlow.current_index) + 1) if typeof(GameFlow) == TYPE_OBJECT else maxi(1, int(RunData.depth) + 1)
	var encounter: Dictionary = HUSHIRO_CATALOG.pick_for_chamber(
		chamber_number,
		RunData.hushiro_encounters_seen
	)
	if encounter.is_empty():
		# This should only occur after unusual debug warp/reload sequences exhaust all
		# unseen eligible encounters. Use an explicit fallback so the chamber remains usable.
		push_warning("[HushiroCombatChamber] No unseen eligible encounter for chamber %d; using Firing Line fallback" % chamber_number)
		encounter = HUSHIRO_CATALOG.get_by_id("H02_firing_line")

	var encounter_id: String = str(encounter.get("id", ""))
	if not encounter_id.is_empty() and not RunData.hushiro_encounters_seen.has(encounter_id):
		RunData.hushiro_encounters_seen.append(encounter_id)

	print("[HushiroCombatChamber] Chamber %d -> %s (%s)" % [
		chamber_number,
		str(encounter.get("name", encounter_id)),
		encounter_id,
	])
	return encounter


func _default_template() -> Dictionary:
	return HUSHIRO_CATALOG.get_by_id("H01_broken_patrol")


# Canonical Hushiro combat rewards are Technique / Gold / Mist / Scroll. Technique
# still enters the existing UpgradeChoiceUI as a compatibility bridge until the
# current Technique screen is connected; the route itself no longer exposes the old
# "boon" vocabulary. Payout values match ITEMS_AND_REWARDS.md.
func post_clear() -> void:
	var reward_key: String = str(get_meta("reward_key") if has_meta("reward_key") else "")
	if reward_key.is_empty():
		reward_key = "technique"

	var runtime_key: String = "boon" if reward_key == "technique" else reward_key
	var amount: int = int(HUSHIRO_COMBAT_PAYOUTS.get(reward_key, 0))

	var spawn_pos := Vector2.ZERO
	var room_center := get_node_or_null("RoomCenter")
	if room_center and room_center is Node2D:
		spawn_pos = (room_center as Node2D).global_position
	else:
		spawn_pos = _spawn_rect.get_center() if _spawn_rect.size != Vector2.ZERO else global_position

	var reward_pickup_script = load("res://Objects/RewardPickup.gd")
	var pickup = reward_pickup_script.new()
	pickup.setup(runtime_key, amount, 1)
	pickup.global_position = spawn_pos
	add_child(pickup)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_reward_spawn", {
			"route_reward": reward_key,
			"runtime_bridge": runtime_key,
			"amount": amount,
		})

	await pickup.collected
	unlock_all_gates()
	print("[HushiroCombatChamber] Reward collected: %s -> gates unlocked" % reward_key)


# Keep the inherited method name because CombatChamberBase invokes it virtually.
func _configure_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	AttackDir.set_role_limits({
		"melee_attack": 1,
		"dog_lunge": 1,
		"advance_move": 2,
		"ranged_attack": 1,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	_apply_hushiro_role_cooldowns()

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = HUSHIRO_GRANT_GAP
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = HUSHIRO_TURNOVER_DELAY
	if _has_property(AttackDir, "max_frontline"):
		AttackDir.max_frontline = 3

	print("[HushiroCombatChamber] Pressure baseline: V2 impact windows + legacy melee cap=1, role-aware frontline autoscale")


static func phase7_pressure_limits(alive: int, hounds: int, frontline_pressure: int = -1) -> Dictionary:
	var safe_alive: int = maxi(0, alive)
	var safe_hounds: int = clampi(hounds, 0, safe_alive)
	# Keep two-argument callers backward compatible by treating unknown role composition
	# as the old coarse all-bodies pressure estimate. Live Hushiro runtime supplies the
	# authored close-pressure count explicitly.
	var safe_frontline_pressure: int = safe_alive if frontline_pressure < 0 else clampi(frontline_pressure, 0, safe_alive)

	# `advance_move` remains conservative outside Hound packs. Hound-heavy encounters
	# gain one extra movement slot because their migrated predator attacks use future
	# impact scheduling rather than whole-turn ownership.
	var advance_limit: int = clampi(safe_alive, 1, 2)
	if safe_hounds >= 3:
		advance_limit = maxi(1, mini(3, safe_alive))

	# Frontline occupancy is a different concern from attack admission. Four or more
	# actual close-pressure bodies may now occupy four slots, while ranged/spatial-heavy
	# waves retain the three-body envelope even when total population reaches six.
	var frontline_limit: int = 3
	if safe_hounds >= 3 or safe_frontline_pressure >= 4:
		frontline_limit = maxi(2, mini(4, safe_alive))
	elif safe_hounds == 2:
		frontline_limit = maxi(2, mini(3, safe_alive))

	return {
		"melee_limit": 1,
		"ranged_limit": 1,
		"advance_limit": advance_limit,
		"frontline_limit": frontline_limit,
		"dog_lunge_limit": 1,
	}


# The shared autoscale timer calls this method as the current wave population changes.
func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	var alive: int = 0
	var hounds: int = 0
	var frontline_pressure: int = 0
	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if not (is_instance_valid(enemy) and is_ancestor_of(enemy)):
			continue
		alive += 1
		var enemy_type: String = str(enemy.get_meta("hushiro_enemy_type", ""))
		if enemy_type == "hound":
			hounds += 1
		if PHASE7_FRONTLINE_PRESSURE_TYPES.has(enemy_type):
			frontline_pressure += 1

	var limits: Dictionary = phase7_pressure_limits(alive, hounds, frontline_pressure)
	var melee_limit: int = int(limits.get("melee_limit", 1))
	var ranged_limit: int = int(limits.get("ranged_limit", 1))
	var advance_limit: int = int(limits.get("advance_limit", 2))
	var frontline_limit: int = int(limits.get("frontline_limit", 3))
	var dog_lunge_limit: int = int(limits.get("dog_lunge_limit", 1))

	AttackDir.set_role_limits({
		"melee_attack": melee_limit,
		"dog_lunge": dog_lunge_limit,
		"advance_move": advance_limit,
		"ranged_attack": ranged_limit,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	_apply_hushiro_role_cooldowns()

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = HUSHIRO_GRANT_GAP
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = HUSHIRO_TURNOVER_DELAY
	if _has_property(AttackDir, "max_frontline"):
		AttackDir.max_frontline = frontline_limit

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_pressure_limits", {
			"alive": alive,
			"hounds": hounds,
			"frontline_pressure": frontline_pressure,
			"melee_limit": melee_limit,
			"ranged_limit": ranged_limit,
			"advance_limit": advance_limit,
			"frontline_limit": frontline_limit,
			"dog_lunge_limit": dog_lunge_limit,
			"policy": "phase7_role_aware_frontline",
		})


func _apply_hushiro_role_cooldowns() -> void:
	AttackDir.set_role_cooldowns({
		"melee_attack": HUSHIRO_MELEE_COOLDOWN,
		"dog_lunge": HUSHIRO_DOG_LUNGE_COOLDOWN,
		"advance_move": HUSHIRO_ADVANCE_COOLDOWN,
		"ranged_attack": HUSHIRO_RANGED_COOLDOWN,
		"frontal": 0.80,
		"flank_left": 0.80,
		"flank_right": 0.80,
	})