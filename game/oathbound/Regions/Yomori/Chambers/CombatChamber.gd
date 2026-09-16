extends "res://Core/Chambers/CombatChamberBase.gd"

## Canonical Yomori combat chamber.
## Owns Region 2 authored encounter selection, denser pressure coordination, and the
## approved Yomori standard-combat persistent/economy payouts.

const YOMORI_CATALOG = preload("res://Regions/Yomori/Encounters/YomoriEncounterCatalog.gd")

const YOMORI_COMBAT_PAYOUTS: Dictionary = {
	"gold": 70,
	"mist": 25,
	"scroll": 1,
}

const YOMORI_MELEE_COOLDOWN: float = 1.05
const YOMORI_ADVANCE_COOLDOWN: float = 0.45
const YOMORI_RANGED_COOLDOWN: float = 1.45


func _ready() -> void:
	name = "YomoriCombatChamber"
	super._ready()
	print("[YomoriCombatChamber] authored Region 2 encounter pool active")


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if area_id != 2:
		return super._pick_encounter_for_area(area_id)

	var chamber_number: int = maxi(1, int(GameFlow.current_index) + 1) if typeof(GameFlow) == TYPE_OBJECT else maxi(1, int(RunData.depth) + 1)
	var seen: Array[String] = RunData.yomori_encounters_seen if typeof(RunData) == TYPE_OBJECT else []
	var encounter := YOMORI_CATALOG.pick_for_chamber(chamber_number, seen)
	if encounter.is_empty():
		push_warning("[YomoriCombatChamber] No eligible authored encounter; using Spirit Patrol fallback")
		encounter = YOMORI_CATALOG.get_by_id("Y01_spirit_patrol")

	var encounter_id := str(encounter.get("id", ""))
	if typeof(RunData) == TYPE_OBJECT and not encounter_id.is_empty() and not RunData.yomori_encounters_seen.has(encounter_id):
		RunData.yomori_encounters_seen.append(encounter_id)

	print("[YomoriCombatChamber] Chamber %d -> %s (%s)" % [chamber_number, str(encounter.get("name", encounter_id)), encounter_id])
	return encounter


func _default_template() -> Dictionary:
	return YOMORI_CATALOG.get_by_id("Y01_spirit_patrol")


func post_clear() -> void:
	var reward_key: String = str(get_meta("reward_key") if has_meta("reward_key") else "")
	if reward_key.is_empty():
		reward_key = "technique"
	var runtime_key := "boon" if reward_key == "technique" else reward_key
	var amount := int(YOMORI_COMBAT_PAYOUTS.get(reward_key, 0))

	var spawn_pos := Vector2.ZERO
	var room_center := get_node_or_null("RoomCenter")
	if room_center is Node2D:
		spawn_pos = (room_center as Node2D).global_position
	else:
		spawn_pos = _spawn_rect.get_center() if _spawn_rect.size != Vector2.ZERO else global_position

	var reward_pickup_script = load("res://Objects/RewardPickup.gd")
	var pickup = reward_pickup_script.new()
	pickup.setup(runtime_key, amount, 2)
	pickup.global_position = spawn_pos
	add_child(pickup)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("yomori_reward_spawn", {
			"route_reward": reward_key,
			"runtime_bridge": runtime_key,
			"amount": amount,
		})

	await pickup.collected
	unlock_all_gates()
	print("[YomoriCombatChamber] Reward collected: %s -> gates unlocked" % reward_key)


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
	_apply_yomori_cooldowns()
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.30
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 0.40
	if _has_property(AttackDir, "max_frontline"):
		AttackDir.max_frontline = 4


func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	var alive := 0
	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and is_ancestor_of(enemy):
			alive += 1

	# Yomori is intentionally denser than Hushiro. It still preserves readable attack
	# ownership, but larger authored waves may overlap one melee and one ranged/control
	# threat or briefly permit a second committed melee attacker.
	var melee_limit := 1 if alive <= 2 else 2
	var ranged_limit := 1 if alive <= 4 else 2
	var advance_limit := clampi(alive, 1, 4)
	AttackDir.set_role_limits({
		"melee_attack": melee_limit,
		"dog_lunge": 1,
		"advance_move": advance_limit,
		"ranged_attack": ranged_limit,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	_apply_yomori_cooldowns()
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.30
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 0.40


func _apply_yomori_cooldowns() -> void:
	AttackDir.set_role_cooldowns({
		"melee_attack": YOMORI_MELEE_COOLDOWN,
		"dog_lunge": 1.90,
		"advance_move": YOMORI_ADVANCE_COOLDOWN,
		"ranged_attack": YOMORI_RANGED_COOLDOWN,
		"frontal": 0.70,
		"flank_left": 0.70,
		"flank_right": 0.70,
	})
