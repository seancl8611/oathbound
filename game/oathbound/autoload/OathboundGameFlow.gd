extends "res://autoload/GameFlow.gd"

## Current Oathbound GameFlow integration authority.
##
## The imported GameFlow remains route/room compatibility plumbing. Current runtime
## systems are first-class project autoloads and are verified here so legacy scene
## paths cannot silently own a run. GameFlow owns the canonical Player factory and
## coordinates run/room Relic events without mutating other autoload scripts at runtime.

const CURRENT_PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const EXPECTED_PLAYER_SCRIPT: String = "res://Player/OathboundCombatPlayer.gd"
const EXPECTED_PROSTHETIC_MANAGER_SCRIPT: String = "res://Core/Prosthetics/OathboundProstheticManager.gd"
const EXPECTED_ATTACK_DIRECTOR_SCRIPT: String = "res://Core/Prosthetics/OathboundAttackDirector.gd"
const EXPECTED_RELIC_RUNTIME_SCRIPT: String = "res://Core/Relics/OathboundRelicRuntime.gd"
const EXPECTED_UPGRADE_SERVICE_SCRIPT: String = "res://Core/Relics/OathboundUpgradeService.gd"
const EXPECTED_PLAYTEST_LAB_SCRIPT: String = "res://Core/Relics/OathboundRelicPlaytestLab.gd"
const RELIC_SWAP_UI_SCRIPT: Script = preload("res://Core/Relics/OathboundRelicSwapUI.gd")


func _ready() -> void:
	# AttackDir and RelicRuntime are declared before GameFlow in project.godot.
	_assert_current_attack_director()
	_assert_current_relic_runtime()

	# These services are declared after GameFlow. Assert them once the autoload setup
	# pass has completed instead of replacing their scripts after _ready().
	call_deferred("_assert_current_upgrade_service")
	call_deferred("_assert_current_prosthetic_manager")
	call_deferred("_assert_current_playtest_lab")

	set_player_scene(CURRENT_PLAYER_SCENE)
	print("[OathboundGameFlow] canonical Player factory -> res://Player/aspect_player.tscn")


func _assert_current_relic_runtime() -> void:
	_assert_autoload_script("RelicRuntime", EXPECTED_RELIC_RUNTIME_SCRIPT, false)


func _assert_current_prosthetic_manager() -> void:
	_assert_autoload_script("ProstheticManager", EXPECTED_PROSTHETIC_MANAGER_SCRIPT, false)


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
	var relic_runtime: Node = _relic_runtime()
	if relic_runtime != null and relic_runtime.has_method("on_new_run"):
		var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else 1
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
	return instance


func set_player(p: Node) -> void:
	# Compatibility callers may still supply a Player, but current RunScene no longer
	# does so. Assert any supplied instance immediately rather than accepting fallback.
	super.set_player(p)
	if p != null and is_instance_valid(p):
		_record_player_runtime("player_factory_assigned", p)


func _load_current_room() -> void:
	# A freed Player reference must not block creation of a fresh current instance.
	if player != null and not is_instance_valid(player):
		player = null
	if _player_packed == null:
		_player_packed = CURRENT_PLAYER_SCENE
	if player == null:
		player = create_player_instance()

	await super._load_current_room()

	if player != null and is_instance_valid(player):
		_record_player_runtime("player_factory_assigned", player)

	var relic_runtime: Node = _relic_runtime()
	if relic_runtime != null and relic_runtime.has_method("on_room_entered"):
		var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else current_area
		var room_token: String = str(route[current_index]) if current_index >= 0 and current_index < route.size() else ""
		relic_runtime.call("on_room_entered", player, area_id, room_token)


func _on_room_cleared(room: Node) -> void:
	var room_token: String = str(route[current_index]) if current_index >= 0 and current_index < route.size() else ""
	var base_key: String = RouteGenerator.get_base_room_type(room_token).to_lower() if not room_token.is_empty() else ""
	if base_key == "combat":
		var relic_runtime: Node = _relic_runtime()
		if relic_runtime != null and relic_runtime.has_method("on_combat_room_cleared"):
			var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else current_area
			relic_runtime.call("on_combat_room_cleared", area_id, room_token)
	await super._on_room_cleared(room)


func _advance_to_next_area() -> void:
	# RELICS.md explicitly allows a safe Relic swap after Keeper and after Twin Maws.
	# Offer the already-unlocked collection before the parent transitions areas.
	var completed_area: int = current_area
	if completed_area == 1:
		await _offer_safe_relic_swap("keeper_transition")
	elif completed_area == 2:
		await _offer_safe_relic_swap("twin_transition")
	await super._advance_to_next_area()


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
