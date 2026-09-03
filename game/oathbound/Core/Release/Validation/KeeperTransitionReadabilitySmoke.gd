extends Node

const KEEPER_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Bosses/Keeper.tscn")
const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const EXPECTED_KEEPER_SCRIPT := "res://Regions/Hushiro/Enemies/Bosses/KeeperReadability.gd"

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	await _verify_keeper_geometry_and_timing()
	await _verify_unblockable_attack_area_contract()
	await _verify_transition_finishes_before_choice_boundary()

	if _failures.is_empty():
		print("[KeeperTransitionReadabilitySmoke] PASS - Keeper readable timing | annular shockwave | telegraph-matched sweep | attack-area defense flags | Area 2 transition clears before choice")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KeeperTransitionReadabilitySmoke] %s" % failure)
		print("[KeeperTransitionReadabilitySmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _verify_keeper_geometry_and_timing() -> void:
	var keeper := KEEPER_SCENE.instantiate()
	add_child(keeper)
	await get_tree().process_frame
	var script_value: Variant = keeper.get_script()
	var script_path := (script_value as Script).resource_path if script_value is Script else ""
	_expect(script_path == EXPECTED_KEEPER_SCRIPT, "Keeper scene script is %s" % script_path)

	_expect(float(keeper.get("discipline_windup")) >= 0.38, "Discipline Cut windup below readability floor")
	_expect(float(keeper.get("blade_dance_hit2_anticipation")) >= 0.32, "Blade Dance hit 2 anticipation below readability floor")
	_expect(float(keeper.get("feral_hit5_anticipation")) >= 0.26, "Feral Onslaught final anticipation below readability floor")
	_expect(float(keeper.get("phase2_min_cooldown")) >= 0.65, "Phase 2 rhythm gap below readability floor")

	keeper.call("_spawn_ring_hitbox", 30.0, 60.0, 19)
	var ring: Area2D = keeper.get("_current_hitbox") as Area2D
	_expect(ring != null, "Keeper shockwave did not create a hitbox")
	if ring != null:
		_expect(str(ring.get_meta("collision_kind", "")) == "annular_ring", "Shockwave is not tagged as annular geometry")
		_expect(bool(ring.get_meta("unblockable", false)), "Shockwave lost unblockable metadata")
		_expect(_collision_polygon_count(ring) >= 12, "Shockwave did not build annular collision segments")
		_expect(_minimum_polygon_radius(ring) >= 29.0, "Outer shockwave band still covers the center like a filled disk")
	keeper.call("_cleanup_hitbox")
	await get_tree().process_frame

	keeper.call("_spawn_sweep_hitbox", 30.0, 100.0, 270.0, 20)
	var sweep: Area2D = keeper.get("_current_hitbox") as Area2D
	_expect(sweep != null, "Keeper sweep did not create a hitbox")
	if sweep != null:
		_expect(str(sweep.get_meta("collision_kind", "")) == "annular_sector", "Sweep is not tagged as annular-sector geometry")
		_expect(absf(float(sweep.get_meta("arc_degrees", 0.0)) - 270.0) <= 0.01, "Sweep collision arc does not match 270-degree telegraph")
		_expect(_collision_polygon_count(sweep) >= 12, "Sweep did not build sector collision segments")
		_expect(_minimum_polygon_radius(sweep) >= 29.0, "Sweep collision still ignores its inner safe radius")
	keeper.call("_cleanup_hitbox")
	keeper.queue_free()
	await get_tree().process_frame


func _verify_unblockable_attack_area_contract() -> void:
	await _exercise_unblockable_defense_case(6, false, "blocking")
	await _exercise_unblockable_defense_case(7, true, "parrying")


func _exercise_unblockable_defense_case(state_value: int, parry_active: bool, label: String) -> void:
	var player := PLAYER_SCENE.instantiate()
	add_child(player)
	await get_tree().process_frame
	player.set("hp", 100)
	player.set("maxhp", 100)
	player.set("stagger", 0.0)
	player.set("is_invincible", false)
	player.set("_is_invincible", false)
	player.set("_playtest_invulnerable", false)
	player.set("_state", state_value)
	player.set("_block_held", state_value == 6)
	player.set("_parry_active", parry_active)

	var source := Node2D.new()
	source.name = "KeeperContractSource"
	source.add_to_group("enemy")
	add_child(source)
	var area := Area2D.new()
	area.name = "KeeperUnblockableFixture"
	area.add_to_group("attack")
	area.set_meta("attacker", source)
	area.set_meta("unblockable", true)
	area.set_meta("parryable", false)
	area.set_meta("damage", 20)
	area.set_meta("damage_type", "keeper_slam")
	add_child(area)

	var hurtbox := player.get_node_or_null("HurtBox") as Area2D
	_expect(hurtbox != null, "Player HurtBox missing for %s fixture" % label)
	if hurtbox != null:
		hurtbox.set_meta("last_attack_source", source)
		hurtbox.set_meta("last_attack_area", area)
	player.call("_on_hurt", 20, "keeper_slam", source)
	_expect(int(player.get("hp")) < 100, "Unblockable attack was incorrectly defended while %s" % label)
	_expect(float(player.get("stagger")) <= 0.001, "Unblockable attack incorrectly resolved as block posture while %s" % label)

	area.queue_free()
	source.queue_free()
	player.queue_free()
	await get_tree().process_frame


func _verify_transition_finishes_before_choice_boundary() -> void:
	var original_run_state: Dictionary = RunData.get_checkpoint_state() if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_checkpoint_state") else {}
	get_tree().paused = false
	await GameFlow.call("_show_area_transition", 2)
	_expect(get_tree().root.get_node_or_null("AreaTransition") == null, "Area transition returned while its layer-200 overlay still existed")

	if typeof(RunData) == TYPE_OBJECT:
		RunData.current_area_id = 2
	GameFlow.call("build_route_for_area", 2)
	await GameFlow.call("_load_current_room")
	_expect(bool(GameFlow.call("is_awaiting_choice")), "Yomori immediate route choice was not presented after transition")
	_expect(get_tree().root.get_node_or_null("AreaTransition") == null, "Yomori choice boundary still has an AreaTransition overlay above it")

	if not original_run_state.is_empty() and RunData.has_method("restore_checkpoint_state"):
		RunData.restore_checkpoint_state(original_run_state)
	get_tree().paused = false


func _collision_polygon_count(area: Area2D) -> int:
	var count := 0
	for child: Node in area.get_children():
		if child is CollisionPolygon2D:
			count += 1
	return count


func _minimum_polygon_radius(area: Area2D) -> float:
	var minimum := INF
	for child: Node in area.get_children():
		if not (child is CollisionPolygon2D):
			continue
		for point: Vector2 in (child as CollisionPolygon2D).polygon:
			minimum = minf(minimum, point.length())
	return minimum if minimum < INF else 0.0


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
