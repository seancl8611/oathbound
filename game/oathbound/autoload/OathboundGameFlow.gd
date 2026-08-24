extends "res://autoload/GameFlow.gd"

## Current Oathbound GameFlow integration authority.
##
## The imported GameFlow remains route/room compatibility plumbing. Current runtime
## systems are first-class project autoloads and are verified here so legacy scene
## paths cannot silently own a run. This layer also owns the approved post-Shogun
## campaign handoff so Area 3 no longer falls through the imported immediate-hub exit.

const CURRENT_PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const EXPECTED_PLAYER_SCRIPT: String = "res://Player/OathboundCombatPlayer.gd"
const EXPECTED_PROSTHETIC_MANAGER_SCRIPT: String = "res://Core/Progression/OathboundPersistentProstheticManager.gd"
const EXPECTED_STRAND_PROGRESSION_SCRIPT: String = "res://Core/Progression/OathboundStrandProgressionManager.gd"
const EXPECTED_ATTACK_DIRECTOR_SCRIPT: String = "res://Core/Prosthetics/OathboundAttackDirector.gd"
const EXPECTED_RELIC_RUNTIME_SCRIPT: String = "res://Core/Relics/OathboundRelicRuntime.gd"
const EXPECTED_CORRUPTION_RUNTIME_SCRIPT: String = "res://Core/Corruption/OathboundCorruptionRuntime.gd"
const EXPECTED_UPGRADE_SERVICE_SCRIPT: String = "res://Core/Relics/OathboundUpgradeService.gd"
const EXPECTED_PLAYTEST_LAB_SCRIPT: String = "res://Core/Regions/OathboundRegionPlaytestLab.gd"
const RELIC_SWAP_UI_SCRIPT: Script = preload("res://Core/Relics/OathboundRelicSwapUI.gd")
const YOMORI_ROUTE_AUTHORITY: Script = preload("res://Regions/Yomori/Routes/YomoriRouteAuthority.gd")
const KAGUTSUCHI_ROUTE_AUTHORITY: Script = preload("res://Regions/Kagutsuchi/Routes/KagutsuchiRouteAuthority.gd")
const ENDGAME_FLOW: Script = preload("res://Core/Endgame/OathboundEndgameFlow.gd")
const HEART_HANDOFF_SCENE: PackedScene = preload("res://Core/Endgame/HeartHandoffChamber.tscn")
const HEART_ENCOUNTER_SHELL_SCENE: PackedScene = preload("res://Core/Endgame/HeartEncounterShell.tscn")

var _endgame_handoff_active := false
var _endgame_outcome := ""
var _final_kagutsuchi_depth_recorded := false


func _ready() -> void:
	_assert_current_attack_director()
	_assert_current_relic_runtime()
	_assert_current_corruption_runtime()
	call_deferred("_assert_current_upgrade_service")
	call_deferred("_assert_current_prosthetic_manager")
	call_deferred("_assert_current_strand_progression_manager")
	call_deferred("_assert_current_playtest_lab")

	var run_complete_cb := Callable(self, "_on_current_run_completed")
	if not run_completed.is_connected(run_complete_cb):
		run_completed.connect(run_complete_cb)

	set_player_scene(CURRENT_PLAYER_SCENE)
	print("[OathboundGameFlow] canonical Player factory -> res://Player/aspect_player.tscn")


func _assert_current_relic_runtime() -> void:
	_assert_autoload_script("RelicRuntime", EXPECTED_RELIC_RUNTIME_SCRIPT, false)


func _assert_current_corruption_runtime() -> void:
	_assert_autoload_script("CorruptionRuntime", EXPECTED_CORRUPTION_RUNTIME_SCRIPT, false)


func _assert_current_prosthetic_manager() -> void:
	_assert_autoload_script("ProstheticManager", EXPECTED_PROSTHETIC_MANAGER_SCRIPT, false)


func _assert_current_strand_progression_manager() -> void:
	_assert_autoload_script("MetaProgressionManager", EXPECTED_STRAND_PROGRESSION_SCRIPT, false)


func _assert_current_attack_director() -> void:
	_assert_autoload_script("AttackDir", EXPECTED_ATTACK_DIRECTOR_SCRIPT, false)


func _assert_current_upgrade_service() -> void:
	_assert_autoload_script("UpgradeService", EXPECTED_UPGRADE_SERVICE_SCRIPT, false)


func _assert_current_playtest_lab() -> void:
	_assert_autoload_script("PlaytestLab", EXPECTED_PLAYTEST_LAB_SCRIPT, true)


func _assert_autoload_script(autoload_name: String, expected_script: String, warn_if_missing: bool) -> void:
	var instance: Node = get_node_or_null("/root/%s" % autoload_name)
	var log_name: String = autoload_name.to_snake_case()
	if autoload_name == "AttackDir":
		log_name = "attack_director"
	if instance == null:
		var message := "[OathboundGameFlow] %s autoload missing" % autoload_name
		if warn_if_missing:
			push_warning(message)
		else:
			push_error(message)
		return
	var installed_path: String = _script_path(instance)
	print("[OathboundGameFlow] %s script=%s" % [log_name, installed_path])
	if installed_path != expected_script:
		push_error("[OathboundGameFlow] Wrong %s script: %s (expected %s)" % [autoload_name, installed_path, expected_script])


func start_run() -> void:
	_endgame_handoff_active = false
	_endgame_outcome = ""
	_final_kagutsuchi_depth_recorded = false
	var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else 1
	var corruption_runtime: Node = _corruption_runtime()
	if corruption_runtime != null and corruption_runtime.has_method("on_new_run"):
		corruption_runtime.call("on_new_run", area_id)
	var relic_runtime: Node = _relic_runtime()
	if relic_runtime != null and relic_runtime.has_method("on_new_run"):
		relic_runtime.call("on_new_run", area_id)
	super.start_run()


func set_player_scene(scene: PackedScene) -> void:
	if scene == null:
		push_error("[OathboundGameFlow] Refusing null Player scene")
		return
	_player_packed = scene


func create_player_instance() -> Node:
	if _player_packed == null:
		_player_packed = CURRENT_PLAYER_SCENE
	var instance: Node = _player_packed.instantiate()
	_record_player_runtime("player_factory_created", instance)
	# Apply permanent capacity only after the Player's own _ready chain has installed
	# its Prosthetic executor and Relic capacity. This runs once for each fresh Player
	# instance and keeps the Strand bonus isolated via manager-owned metadata.
	call_deferred("_apply_strand_progression_to_player", instance)
	return instance


func _apply_strand_progression_to_player(instance: Node) -> void:
	if instance == null or not is_instance_valid(instance):
		return
	if not instance.is_node_ready():
		await instance.ready
	if instance == null or not is_instance_valid(instance):
		return
	var progression: Node = get_node_or_null("/root/MetaProgressionManager")
	if progression != null and progression.has_method("apply_player_capacity"):
		progression.call("apply_player_capacity", instance)
		print("[OathboundGameFlow] Strand capacity applied to canonical Player")


func set_player(p: Node) -> void:
	super.set_player(p)
	if p != null and is_instance_valid(p):
		_record_player_runtime("player_factory_assigned", p)


func build_route_for_area(area_id: int) -> Array[String]:
	current_area = area_id
	var generated_value: Variant = []
	if area_id == 2:
		generated_value = YOMORI_ROUTE_AUTHORITY.generate(RouteGenerator)
	elif area_id == 3:
		generated_value = KAGUTSUCHI_ROUTE_AUTHORITY.generate(RouteGenerator)
	else:
		generated_value = RouteGenerator.generate_area_route(area_id)

	var generated: Array[String] = []
	if generated_value is Array:
		for token_value: Variant in generated_value:
			generated.append(str(token_value))
	route = generated
	current_index = 0
	_awaiting_choice = false
	_choice_slot = -1
	if area_id == 3:
		_final_kagutsuchi_depth_recorded = false
	return route


func _load_current_room() -> void:
	if player != null and not is_instance_valid(player):
		player = null
	if _player_packed == null:
		_player_packed = CURRENT_PLAYER_SCENE
	if player == null:
		player = create_player_instance()

	var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else current_area
	if typeof(SceneRegistry) == TYPE_OBJECT and SceneRegistry.has_method("activate_area"):
		SceneRegistry.call("activate_area", area_id)

	await super._load_current_room()

	if player != null and is_instance_valid(player):
		_record_player_runtime("player_factory_assigned", player)

	var room_token: String = str(route[current_index]) if current_index >= 0 and current_index < route.size() else ""
	var corruption_runtime: Node = _corruption_runtime()
	if corruption_runtime != null and corruption_runtime.has_method("on_room_entered"):
		corruption_runtime.call("on_room_entered", room_token)

	var relic_runtime: Node = _relic_runtime()
	if relic_runtime != null and relic_runtime.has_method("on_room_entered"):
		relic_runtime.call("on_room_entered", player, area_id, room_token)


func _on_room_cleared(room: Node) -> void:
	var room_token: String = str(route[current_index]) if current_index >= 0 and current_index < route.size() else ""
	var corruption_runtime: Node = _corruption_runtime()
	if corruption_runtime != null and corruption_runtime.has_method("on_room_cleared"):
		corruption_runtime.call("on_room_cleared", room_token)

	var base_key: String = RouteGenerator.get_base_room_type(room_token).to_lower() if not room_token.is_empty() else ""
	if base_key == "combat":
		var relic_runtime: Node = _relic_runtime()
		if relic_runtime != null and relic_runtime.has_method("on_combat_room_cleared"):
			var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else current_area
			relic_runtime.call("on_combat_room_cleared", area_id, room_token)
	await super._on_room_cleared(room)


# =============================================================================
# POST-SHOGUN CAMPAIGN / HEART HANDOFF
# =============================================================================

func next_room() -> void:
	# The imported GameFlow would return directly to Hub after Area 3. Intercept only
	# the actual final Kagutsuchi route node; all earlier regional routing stays on the
	# proven compatibility path.
	if current_area == 3 and not route.is_empty() and current_index >= route.size() - 1:
		if _endgame_handoff_active:
			return
		_endgame_handoff_active = true
		_record_final_kagutsuchi_depth()
		await _begin_post_shogun_handoff()
		return
	super.next_room()


func _record_final_kagutsuchi_depth() -> void:
	if _final_kagutsuchi_depth_recorded:
		return
	_final_kagutsuchi_depth_recorded = true
	if typeof(RunData) != TYPE_OBJECT or current_index < 0 or current_index >= route.size():
		return
	var token := str(route[current_index])
	RunData.advance_depth(token)
	print("[OathboundGameFlow] Counted route complete depth=%d token=%s" % [int(RunData.depth), token])


func _begin_post_shogun_handoff() -> void:
	var meta: Node = get_node_or_null("/root/MetaProgress")
	var rd: Node = get_node_or_null("/root/RunData")
	_endgame_outcome = str(ENDGAME_FLOW.determine_shogun_outcome(meta, rd))
	print("[OathboundGameFlow] Shogun outcome=%s goal=%s bindings=%d story_complete=%s" % [
		_endgame_outcome,
		str(RunData.get_run_goal()) if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_run_goal") else "",
		int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_heart_bindings_destroyed") else -1,
		str(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") else "unknown",
	])
	_record_endgame_event("shogun_handoff_selected", {"outcome": _endgame_outcome})

	if _endgame_outcome == ENDGAME_FLOW.OUTCOME_STANDARD_EXPEDITION:
		if not ENDGAME_FLOW.complete_standard_expedition(meta):
			push_error("[OathboundGameFlow] Standard Expedition completion could not be persisted")
			_endgame_handoff_active = false
			return
		if typeof(RunData) == TYPE_OBJECT:
			RunData.mark_run_completion("standard_expedition")
		_finish_successful_run_to_strand()
		return

	if ENDGAME_FLOW.requires_heart_entry_recovery(_endgame_outcome):
		ENDGAME_FLOW.apply_shogun_to_heart_recovery(player)

	await _load_heart_handoff(_endgame_outcome)


func _load_heart_handoff(outcome: String) -> void:
	var chamber := HEART_HANDOFF_SCENE.instantiate()
	chamber.set_meta("endgame_outcome", outcome)
	if chamber.has_signal("handoff_completed"):
		chamber.connect("handoff_completed", Callable(self, "_on_heart_handoff_completed"))
	await _replace_room_with_specialized_scene(chamber)
	_record_endgame_event("heart_handoff_loaded", {"outcome": outcome})


func _on_heart_handoff_completed(outcome: String) -> void:
	if outcome != _endgame_outcome:
		push_warning("[OathboundGameFlow] Heart handoff outcome drift: %s != %s" % [outcome, _endgame_outcome])
	match outcome:
		ENDGAME_FLOW.OUTCOME_BINDING_COMPLETION:
			if not ENDGAME_FLOW.complete_binding(get_node_or_null("/root/MetaProgress")):
				push_error("[OathboundGameFlow] Binding completion rejected by persistent campaign state")
				return
			var destroyed := int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT else 0
			if typeof(RunData) == TYPE_OBJECT:
				RunData.mark_run_completion("binding_%d" % destroyed)
			_record_endgame_event("heart_binding_destroyed", {"destroyed": destroyed, "remaining": maxi(0, 6 - destroyed)})
			_finish_successful_run_to_strand()
		ENDGAME_FLOW.OUTCOME_PRE_AWAKENED_HEART_CONTACT:
			var corruption_runtime := _corruption_runtime()
			if corruption_runtime != null and corruption_runtime.has_method("on_player_death"):
				corruption_runtime.call("on_player_death")
			elif typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("awaken_returning_blood"):
				MetaProgress.call("awaken_returning_blood")
			if typeof(RunData) == TYPE_OBJECT:
				RunData.mark_run_completion("pre_awakened_heart_contact")
			_record_endgame_event("pre_awakened_heart_contact", {"awakened": true})
			_return_to_strand(false)
		ENDGAME_FLOW.OUTCOME_TRUE_FINAL_HEART, ENDGAME_FLOW.OUTCOME_HEART_SUPPRESSION:
			await _load_heart_encounter_shell(outcome)
		_:
			push_error("[OathboundGameFlow] Unsupported Heart handoff outcome: %s" % outcome)


func _load_heart_encounter_shell(outcome: String) -> void:
	var shell := HEART_ENCOUNTER_SHELL_SCENE.instantiate()
	shell.set_meta("postgame_suppression", outcome == ENDGAME_FLOW.OUTCOME_HEART_SUPPRESSION)
	if shell.has_signal("heart_defeated"):
		shell.connect("heart_defeated", Callable(self, "_on_heart_defeated"))
	await _replace_room_with_specialized_scene(shell)
	_record_endgame_event("heart_encounter_shell_loaded", {
		"postgame_suppression": outcome == ENDGAME_FLOW.OUTCOME_HEART_SUPPRESSION,
		"combat_moveset": "deferred_by_authority",
	})


func _on_heart_defeated(postgame_suppression: bool) -> void:
	var meta: Node = get_node_or_null("/root/MetaProgress")
	if not ENDGAME_FLOW.complete_heart_victory(meta, postgame_suppression):
		push_error("[OathboundGameFlow] Heart victory could not be persisted")
		return
	if typeof(RunData) == TYPE_OBJECT:
		RunData.mark_run_completion("heart_suppression" if postgame_suppression else "story_complete")
	_record_endgame_event("heart_victory", {"postgame_suppression": postgame_suppression})
	_finish_successful_run_to_strand()


func _replace_room_with_specialized_scene(scene: Node) -> void:
	if room_container == null or scene == null:
		push_error("[OathboundGameFlow] Cannot load specialized endgame scene without room container")
		return

	if player != null and is_instance_valid(player) and player.get_parent() != null:
		player.get_parent().remove_child(player)
	for child: Node in room_container.get_children():
		child.queue_free()
	await get_tree().process_frame

	room_container.add_child(scene)
	await get_tree().process_frame

	if player == null or not is_instance_valid(player):
		push_error("[OathboundGameFlow] Canonical Player was lost during endgame handoff")
		return
	if player is Node:
		player.set_physics_process(false)
	if player is CanvasItem:
		player.visible = false
	room_container.add_child(player)
	await get_tree().process_frame

	var spawn := scene.get_node_or_null("PlayerSpawn")
	if spawn is Node2D and player is Node2D:
		(player as Node2D).global_position = (spawn as Node2D).global_position
	if player is Node:
		player.set_physics_process(true)
	if player is CanvasItem:
		player.visible = true
		(player as CanvasItem).modulate.a = 1.0
	_record_player_runtime("player_factory_assigned", player)


func _finish_successful_run_to_strand() -> void:
	emit_signal("run_completed", 3)
	_return_to_strand(true)


func _return_to_strand(successful: bool) -> void:
	print("[OathboundGameFlow] Returning to Strand successful=%s completion=%s" % [
		str(successful),
		str(RunData.run_completion_kind) if typeof(RunData) == TYPE_OBJECT else "",
	])
	current_area = 1
	current_index = 0
	_endgame_handoff_active = false
	_endgame_outcome = ""
	if typeof(RunData) == TYPE_OBJECT:
		RunData.current_area_id = 1
	get_tree().change_scene_to_file(HUB_SCENE_PATH)


func _record_endgame_event(event_name: String, data: Dictionary) -> void:
	print("[EndgameFlow] %s %s" % [event_name, str(data)])
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, data)


func _on_current_run_completed(area_id: int) -> void:
	if area_id < max_area:
		return
	var corruption_runtime: Node = _corruption_runtime()
	if corruption_runtime != null and corruption_runtime.has_method("on_successful_run_completed"):
		corruption_runtime.call("on_successful_run_completed")


func _advance_to_next_area() -> void:
	var completed_area: int = current_area
	if completed_area == 1:
		await _offer_safe_relic_swap("keeper_transition")
	elif completed_area == 2:
		await _offer_safe_relic_swap("twin_transition")

	current_area += 1
	print("[OathboundGameFlow] Advancing to Area %d" % current_area)
	if typeof(RunData) == TYPE_OBJECT:
		RunData.current_area_id = current_area

	await _show_area_transition(current_area)
	build_route_for_area(current_area)
	_load_current_room()


func _offer_safe_relic_swap(context: String) -> void:
	var runtime: Node = _relic_runtime()
	if runtime == null:
		return
	var unlocked_value: Variant = runtime.get("unlocked_relics")
	if not (unlocked_value is Dictionary) or (unlocked_value as Dictionary).is_empty():
		return

	var ui_value: Variant = RELIC_SWAP_UI_SCRIPT.new()
	if not (ui_value is CanvasLayer):
		push_error("[OathboundGameFlow] Could not instantiate Relic safe-swap UI")
		return
	var ui: CanvasLayer = ui_value as CanvasLayer
	get_tree().root.add_child(ui)
	if not ui.has_method("present") or not ui.has_signal("selection_finished"):
		ui.queue_free()
		push_error("[OathboundGameFlow] Relic safe-swap UI contract invalid")
		return
	var finished_signal := Signal(ui, &"selection_finished")
	ui.call("present", context)
	await finished_signal


func _record_player_runtime(event_name: String, instance: Node) -> void:
	if instance == null or not is_instance_valid(instance):
		return
	var script_path: String = _script_path(instance)
	print("[OathboundGameFlow] %s script=%s" % [event_name, script_path])
	if script_path != EXPECTED_PLAYER_SCRIPT:
		push_error("[OathboundGameFlow] Wrong active Player script: %s (expected %s)" % [script_path, EXPECTED_PLAYER_SCRIPT])
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, {
			"player_script": script_path,
			"expected_player_script": EXPECTED_PLAYER_SCRIPT,
			"matches_expected": script_path == EXPECTED_PLAYER_SCRIPT,
		})


func _script_path(instance: Object) -> String:
	if instance == null:
		return ""
	var script_value: Variant = instance.get_script()
	if script_value is Script:
		return (script_value as Script).resource_path
	return ""


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")


func _corruption_runtime() -> Node:
	return get_node_or_null("/root/CorruptionRuntime")
