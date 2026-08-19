extends "res://Areas/Area1/CombatRoom.gd"

## Current Area 1 combat-room rules layer.
## Legacy CombatRoom still supplies reward/gate plumbing while Hushiro-specific
## encounter selection and pressure coordination are reconciled here.

const HushiroEncounterCatalog = preload("res://Areas/Area1/HushiroEncounterCatalog.gd")


func _ready() -> void:
	print("[HushiroCombatRoom] Authored multi-wave combat active")
	add_child(ui)
	ui.visible = false
	ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	ui.layer = 100

	var cam: Camera2D = get_viewport().get_camera_2d()
	if cam and room_bounds and room_bounds.has_method("apply_camera_limits"):
		room_bounds.call("apply_camera_limits", cam)

	if room_bounds and room_bounds.has_method("get_rect_global"):
		_spawn_rect = room_bounds.call("get_rect_global") as Rect2
	else:
		_spawn_rect = Rect2(global_position - Vector2(800, 450), Vector2(1600, 900))

	_push_spawn_rect_to_spawner(_spawn_rect)
	lock_all_gates()
	_configure_duel_tokens()
	_start_encounter()


# Keep the inherited method name because legacy CombatRoom calls it, but configure
# readable Hushiro group pressure rather than the old long-cooldown duel preset.
func _configure_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	AttackDir.set_role_limits({
		"melee_attack": 1,
		"advance_move": 3,
		"ranged_attack": 1,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	AttackDir.set_role_cooldowns({
		"melee_attack": 1.6,
		"advance_move": 0.8,
		"ranged_attack": 1.8,
		"frontal": 0.8,
		"flank_left": 0.8,
		"flank_right": 0.8,
	})

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.55
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 0.65

	print("[HushiroCombatRoom] Coordination: 1 committed melee, 3 advance, 1 ranged")


func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	var alive: int = 0
	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and is_ancestor_of(enemy):
			alive += 1

	var advance_limit: int = clampi(alive, 1, 3)
	AttackDir.set_role_limits({
		"melee_attack": 1,
		"advance_move": advance_limit,
		"ranged_attack": 1,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})
	AttackDir.set_role_cooldowns({
		"melee_attack": 1.6,
		"advance_move": 0.8,
		"ranged_attack": 1.8,
		"frontal": 0.8,
		"flank_left": 0.8,
		"flank_right": 0.8,
	})
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 0.55


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if area_id != 1:
		return super._pick_encounter_for_area(area_id)

	var chamber_number: int = 1
	if typeof(GameFlow) == TYPE_OBJECT:
		chamber_number = maxi(1, int(GameFlow.current_index) + 1)
	elif typeof(RunData) == TYPE_OBJECT:
		chamber_number = maxi(1, int(RunData.depth) + 1)

	var seen: Array[String] = []
	if typeof(RunData) == TYPE_OBJECT:
		seen = RunData.hushiro_encounters_seen

	var encounter: Dictionary = HushiroEncounterCatalog.pick_for_chamber(chamber_number, seen)
	if encounter.is_empty():
		push_warning("[HushiroCombatRoom] No unseen eligible encounter for chamber %d; using Broken Patrol fallback" % chamber_number)
		encounter = HushiroEncounterCatalog.get_by_id("H01_broken_patrol")

	var encounter_id: String = str(encounter.get("id", ""))
	if typeof(RunData) == TYPE_OBJECT and not encounter_id.is_empty():
		if not RunData.hushiro_encounters_seen.has(encounter_id):
			RunData.hushiro_encounters_seen.append(encounter_id)

	print("[HushiroCombatRoom] Chamber %d -> %s (%s)" % [
		chamber_number,
		str(encounter.get("name", encounter_id)),
		encounter_id,
	])
	return encounter


func _default_template() -> Dictionary:
	return HushiroEncounterCatalog.get_by_id("H01_broken_patrol")
