extends "res://Core/Chambers/CombatChamberBase.gd"

## Canonical Kagutsuchi combat chamber.
## Owns Region 3 authored encounter selection, Court pressure coordination, and the
## approved Kagutsuchi standard-combat persistent/economy payouts.

const KAGUTSUCHI_CATALOG = preload("res://Regions/Kagutsuchi/Encounters/KagutsuchiEncounterCatalog.gd")

const KAGUTSUCHI_COMBAT_PAYOUTS: Dictionary = {
	"gold": 80,
	"mist": 30,
	"scroll": 2,
}

const COURT_MELEE_COOLDOWN: float = 0.95
const COURT_ADVANCE_COOLDOWN: float = 0.40
const COURT_RANGED_COOLDOWN: float = 1.35


func _ready() -> void:
	name = "KagutsuchiCombatChamber"
	super._ready()
	print("[KagutsuchiCombatChamber] authored Region 3 encounter pool active")


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if area_id != 3:
		return super._pick_encounter_for_area(area_id)

	var chamber_number: int = maxi(1, int(GameFlow.current_index) + 1) if typeof(GameFlow) == TYPE_OBJECT else maxi(1, int(RunData.depth) + 1)
	var seen: Array[String] = RunData.kagutsuchi_encounters_seen if typeof(RunData) == TYPE_OBJECT else []
	var encounter := KAGUTSUCHI_CATALOG.pick_for_chamber(chamber_number, seen)
	if encounter.is_empty():
		push_warning("[KagutsuchiCombatChamber] No eligible authored encounter; using Retainer Pair fallback")
		encounter = KAGUTSUCHI_CATALOG.get_by_id("K01_retainer_pair")

	var encounter_id := str(encounter.get("id", ""))
	if typeof(RunData) == TYPE_OBJECT and not encounter_id.is_empty() and not RunData.kagutsuchi_encounters_seen.has(encounter_id):
		RunData.kagutsuchi_encounters_seen.append(encounter_id)

	print("[KagutsuchiCombatChamber] Chamber %d -> %s (%s)" % [chamber_number, str(encounter.get("name", encounter_id)), encounter_id])
	return encounter


func _default_template() -> Dictionary:
	return KAGUTSUCHI_CATALOG.get_by_id("K01_retainer_pair")


func post_clear() -> void:
	var reward_key: String = str(get_meta("reward_key") if has_meta("reward_key") else "")
	if reward_key.is_empty():
		reward_key = "technique"
	var runtime_key := "boon" if reward_key == "technique" else reward_key
	var amount := int(KAGUTSUCHI_COMBAT_PAYOUTS.get(reward_key, 0))

	var spawn_pos := Vector2.ZERO
	var room_center := get_node_or_null("RoomCenter")
	if room_center is Node2D:
		spawn_pos = (room_center as Node2D).global_position
	else:
		spawn_pos = _spawn_rect.get_center() if _spawn_rect.size != Vector2.ZERO else global_position

	var reward_pickup_script = load("res://Objects/RewardPickup.gd")
	var pickup = reward_pickup_script.new()
	pickup.setup(runtime_key, amount, 3)
	pickup.global_position = spawn_pos
	add_child(pickup)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("kagutsuchi_reward_spawn", {
			"route_reward": reward_key,
			"runtime_bridge": runtime_key,
			"amount": amount,
		})

	await pickup.collected
	unlock_all_gates()
	print("[KagutsuchiCombatChamber] Reward collected: %s -> gates unlocked" % reward_key)


func _configure_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	AttackDir.set_role_limits({
		"melee_attack": 2,
		"dog_lunge": 0,
		"advance_move": 3,
		"ranged_attack": 1,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	_apply_court_cooldowns()
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.25
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 0.35
	if _has_property(AttackDir, "max_frontline"):
		AttackDir.max_frontline = 4


func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	var alive := 0
	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and is_ancestor_of(enemy):
			alive += 1

	# Court enemies are mechanically dense. Preserve simultaneous role ownership so
	# revival, spawning, shielding, and frenzy remain readable rather than allowing
	# every elite unit to attack at once.
	var melee_limit := 1 if alive <= 2 else 2
	var ranged_limit := 1 if alive <= 4 else 2
	var advance_limit := clampi(alive, 1, 4)
	AttackDir.set_role_limits({
		"melee_attack": melee_limit,
		"dog_lunge": 0,
		"advance_move": advance_limit,
		"ranged_attack": ranged_limit,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	_apply_court_cooldowns()
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.25
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 0.35


func _apply_court_cooldowns() -> void:
	AttackDir.set_role_cooldowns({
		"melee_attack": COURT_MELEE_COOLDOWN,
		"dog_lunge": 2.0,
		"advance_move": COURT_ADVANCE_COOLDOWN,
		"ranged_attack": COURT_RANGED_COOLDOWN,
		"frontal": 0.60,
		"flank_left": 0.60,
		"flank_right": 0.60,
	})
