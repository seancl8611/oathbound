extends "res://Areas/Area1/CombatRoom.gd"

## Current Area 1 combat-room rules layer.
##
## Legacy CombatRoom still owns general gate/room plumbing. Hushiro-specific encounter
## selection, pressure coordination, and current reward compatibility live here so
## Area 1 follows the approved authored model without reviving old route authority.

const HUSHIRO_CATALOG = preload("res://Utility/HushiroEncounterCatalog.gd")

const HUSHIRO_MELEE_COOLDOWN: float = 1.20
const HUSHIRO_ADVANCE_COOLDOWN: float = 0.55
const HUSHIRO_RANGED_COOLDOWN: float = 1.60
const HUSHIRO_GRANT_GAP: float = 0.35
const HUSHIRO_TURNOVER_DELAY: float = 0.50

const HUSHIRO_COMBAT_PAYOUTS: Dictionary = {
	"gold": 60,
	"mist": 20,
	"scroll": 1,
}


func _ready() -> void:
	# The inherited ready path still owns bounds, gates and encounter startup.
	# Its virtual calls dispatch to the Hushiro overrides below.
	super._ready()
	print("[HushiroCombatRoom] Authored Hushiro encounter coordination active")


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if area_id != 1:
		return super._pick_encounter_for_area(area_id)

	var chamber_number: int = maxi(1, int(RunData.depth) + 1)
	var encounter: Dictionary = HUSHIRO_CATALOG.pick_for_chamber(
		chamber_number,
		RunData.hushiro_encounters_seen
	)
	if encounter.is_empty():
		# This should only occur after unusual debug warp/reload sequences exhaust all
		# unseen eligible encounters. Use an explicit fallback so the room remains usable.
		push_warning("[HushiroCombatRoom] No unseen eligible encounter for chamber %d; using Firing Line fallback" % chamber_number)
		encounter = HUSHIRO_CATALOG.get_by_id("H02_firing_line")

	var encounter_id: String = str(encounter.get("id", ""))
	if not encounter_id.is_empty() and not RunData.hushiro_encounters_seen.has(encounter_id):
		RunData.hushiro_encounters_seen.append(encounter_id)

	print("[HushiroCombatRoom] Chamber %d -> %s (%s)" % [
		chamber_number,
		str(encounter.get("name", encounter_id)),
		encounter_id,
	])
	return encounter


func _default_template() -> Dictionary:
	return HUSHIRO_CATALOG.get_by_id("H01_broken_patrol")


# Canonical Area 1 route tokens are Technique / Gold / Mist / Scroll. Technique still
# enters the existing UpgradeChoiceUI as a compatibility bridge until the current
# Technique screen is connected; the route itself no longer exposes the old "boon"
# vocabulary. Payout values match ITEMS_AND_REWARDS.md.
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
	print("[HushiroCombatRoom] Reward collected: %s -> gates unlocked" % reward_key)


# Keep the inherited method name because CombatRoom invokes it virtually.
func _configure_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	AttackDir.set_role_limits({
		"melee_attack": 1,
		"dog_lunge": 1,
		"advance_move": 3,
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
		AttackDir.max_frontline = 4

	print("[HushiroCombatRoom] Pressure baseline: adaptive melee/ranged roles, Hound lunge cap=1")


# The imported autoscale timer calls this method as the current wave population changes.
func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	var alive: int = 0
	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and is_ancestor_of(enemy):
			alive += 1

	# Low-body-count exchanges remain precise. The authored 4-6 body waves may permit
	# modest overlap so Hushiro does not collapse back into sequential one-on-one duels.
	var melee_limit: int = 1 if alive <= 3 else 2
	var ranged_limit: int = 1 if alive <= 4 else 2
	var advance_limit: int = clampi(alive, 1, 4)

	AttackDir.set_role_limits({
		"melee_attack": melee_limit,
		"dog_lunge": 1,
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

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_pressure_limits", {
			"alive": alive,
			"melee_limit": melee_limit,
			"ranged_limit": ranged_limit,
			"advance_limit": advance_limit,
			"dog_lunge_limit": 1,
		})


func _apply_hushiro_role_cooldowns() -> void:
	AttackDir.set_role_cooldowns({
		"melee_attack": HUSHIRO_MELEE_COOLDOWN,
		"dog_lunge": 2.20,
		"advance_move": HUSHIRO_ADVANCE_COOLDOWN,
		"ranged_attack": HUSHIRO_RANGED_COOLDOWN,
		"frontal": 0.80,
		"flank_left": 0.80,
		"flank_right": 0.80,
	})
