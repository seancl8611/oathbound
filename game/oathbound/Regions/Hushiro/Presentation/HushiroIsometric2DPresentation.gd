extends Node

## Hushiro's live 2D isometric presentation bridge.
##
## Combat remains entirely authoritative on existing Node2D/CharacterBody2D actors.
## This bridge owns framing plus replacement body presentation only. The first production
## content proof is intentionally scoped to Akio + Corrupted Swordsman via two rig-ready
## DirectionalSpriteProfile resources. Every other role remains on readable placeholders.

const DIRECTIONAL_PRESENTER_SCRIPT = preload("res://Utility/DirectionalActorPresentation.gd")
const AKIO_RIG2D_PROFILE = preload("res://Presentation/Profiles/AkioRigRendered2DProfile.tres")
const SWORDSMAN_RIG2D_PROFILE = preload("res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres")

@export_category("Isometric combat framing")
@export_range(0.35, 0.75, 0.01) var presentation_zoom: float = 0.50
@export_range(0.55, 0.90, 0.01) var ground_vertical_compression: float = 0.72
@export var framing_world_offset := Vector2(0.0, -12.0)

@export_category("Actor presentation")
@export var player_visual_scale: float = 1.0
@export var standard_enemy_visual_scale: float = 1.0
@export_range(0.03, 0.50, 0.01) var actor_refresh_seconds: float = 0.08

var _presenter_root: Node2D = null
var _presenters: Dictionary = {}
var _refresh_left: float = 0.0
var _camera_configured_id: int = 0
var _startup_reported := false


func _ready() -> void:
	_presenter_root = Node2D.new()
	_presenter_root.name = "DirectionalActorLayer"
	_presenter_root.y_sort_enabled = false
	add_child(_presenter_root)
	call_deferred("_activate")


func _exit_tree() -> void:
	_restore_all_legacy_bodies()


func _process(delta: float) -> void:
	_configure_camera_if_needed()
	_refresh_left -= delta
	if _refresh_left <= 0.0:
		_refresh_left = actor_refresh_seconds
		_reconcile_actors()


func _activate() -> void:
	if not is_inside_tree():
		return
	_configure_camera_if_needed()
	_reconcile_actors()
	_report_startup_once()


func _configure_camera_if_needed() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null or not is_instance_valid(camera):
		return
	var camera_id := camera.get_instance_id()
	if camera_id == _camera_configured_id:
		return

	_set_if_present(camera, "presentation_zoom", presentation_zoom)
	_set_if_present(camera, "ground_vertical_compression", ground_vertical_compression)
	_set_if_present(camera, "framing_world_offset", framing_world_offset)
	_set_if_present(camera, "compensate_character_sprites", false)
	_set_if_present(camera, "compensate_world_controls", true)
	_set_if_present(camera, "use_procedural_actor_proxies", false)
	_set_if_present(camera, "hide_legacy_actor_sprites_when_proxying", false)
	_set_if_present(camera, "add_contact_shadows", false)
	_set_if_present(camera, "depth_sort_characters", true)
	_set_if_present(camera, "show_prototype_badge", false)

	if camera.has_method("set_three_quarter_enabled"):
		camera.call("set_three_quarter_enabled", true)
	elif camera.has_method("_apply_presentation_profile"):
		camera.call("_apply_presentation_profile")
	if camera.has_method("snap_to_target"):
		camera.call("snap_to_target")

	_camera_configured_id = camera_id
	_report_startup_once()


func _set_if_present(object: Object, property_name: String, value: Variant) -> void:
	if object == null or not is_instance_valid(object):
		return
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			object.set(property_name, value)
			return


func _report_startup_once() -> void:
	if _startup_reported or _camera_configured_id == 0:
		return
	_startup_reported = true
	print(
		"[HushiroIsometric2D] revision=2 runtime=2d directional=8 zoom=%.2f compression=%.2f live_3d=false rig2d_profiles=akio+swordsman pixel_art_ready=true"
		% [presentation_zoom, ground_vertical_compression]
	)


func _reconcile_actors() -> void:
	if _presenter_root == null or not is_instance_valid(_presenter_root):
		return
	var seen: Dictionary = {}
	for actor: Node2D in _presentation_actors():
		if actor == null or not is_instance_valid(actor):
			continue
		var actor_id := actor.get_instance_id()
		seen[actor_id] = true
		var existing_value: Variant = _presenters.get(actor_id, null)
		if _is_live_object(existing_value):
			continue
		_presenters.erase(actor_id)
		_add_presenter(actor)

	for actor_id: Variant in _presenters.keys():
		if seen.has(actor_id):
			continue
		var presenter_value: Variant = _presenters.get(actor_id, null)
		if _is_live_object(presenter_value) and presenter_value is Node:
			(presenter_value as Node).queue_free()
		_presenters.erase(actor_id)


func _add_presenter(actor: Node2D) -> void:
	if actor == null or not is_instance_valid(actor) or _presenter_root == null:
		return
	var presenter_value: Variant = DIRECTIONAL_PRESENTER_SCRIPT.new()
	if not _is_live_object(presenter_value) or not (presenter_value is Node2D):
		return
	var presenter := presenter_value as Node2D
	presenter.name = "DirectionalActor_%s" % str(actor.get_instance_id())
	_presenter_root.add_child(presenter)
	var role := _role_for(actor)
	var scale_factor := player_visual_scale if role == "player" else _role_scale(role)
	if presenter.has_method("configure"):
		presenter.call("configure", actor, role, scale_factor, ground_vertical_compression)
	var profile := _profile_for_role(role)
	if profile != null and presenter.has_method("set_profile"):
		presenter.call("set_profile", profile)
	_presenters[actor.get_instance_id()] = presenter


func _profile_for_role(role: String) -> Resource:
	match role:
		"player":
			return AKIO_RIG2D_PROFILE
		"swordsman":
			return SWORDSMAN_RIG2D_PROFILE
		_:
			return null


func _role_scale(role: String) -> float:
	match role:
		"hollow": return standard_enemy_visual_scale * 0.92
		"hound": return standard_enemy_visual_scale * 0.92
		"archer": return standard_enemy_visual_scale * 0.96
		"swordsman": return standard_enemy_visual_scale
		"bilemass": return standard_enemy_visual_scale * 1.08
		"warden": return standard_enemy_visual_scale * 1.16
		_: return standard_enemy_visual_scale


func _presentation_actors() -> Array[Node2D]:
	var actors: Array[Node2D] = []
	var tree := get_tree()
	if tree == null:
		return actors
	var room := get_parent()
	for group_name: StringName in [&"player", &"enemy"]:
		for candidate: Node in tree.get_nodes_in_group(group_name):
			if candidate == null or not is_instance_valid(candidate) or not (candidate is Node2D):
				continue
			if group_name == &"enemy" and room != null and not room.is_ancestor_of(candidate):
				continue
			actors.append(candidate as Node2D)
	return actors


func _role_for(actor: Node2D) -> String:
	if actor.is_in_group("player"):
		return "player"
	for key: StringName in [&"presentation_role", &"enemy_type", &"hushiro_enemy_type"]:
		var value := str(actor.get_meta(key, "")).strip_edges().to_lower()
		if not value.is_empty():
			return value
	var identity := str(actor.name).to_lower()
	var script_value: Variant = actor.get_script()
	if script_value is Script:
		identity += " " + (script_value as Script).resource_path.to_lower()
	for role: String in ["swordsman", "hound", "hollow", "archer", "bilemass", "warden"]:
		if identity.contains(role):
			return role
	return "enemy"


func _restore_all_legacy_bodies() -> void:
	for presenter_value: Variant in _presenters.values():
		if not _is_live_object(presenter_value) or not (presenter_value is Node):
			continue
		var presenter := presenter_value as Node
		if presenter.has_method("_restore_legacy_body"):
			presenter.call("_restore_legacy_body")


func _is_live_object(value: Variant) -> bool:
	return value != null and typeof(value) == TYPE_OBJECT and is_instance_valid(value)


func get_presentation_state_for_test() -> Dictionary:
	var camera := get_viewport().get_camera_2d()
	var actor_states: Array[Dictionary] = []
	var profiled_presenters := 0
	for presenter_value: Variant in _presenters.values():
		if not _is_live_object(presenter_value) or not (presenter_value is Node):
			continue
		var presenter := presenter_value as Node
		if presenter.has_method("get_presentation_state_for_test"):
			var state_value: Variant = presenter.call("get_presentation_state_for_test")
			if state_value is Dictionary:
				var actor_state := (state_value as Dictionary).duplicate(true)
				actor_states.append(actor_state)
				if not str(actor_state.get("profile_id", "")).is_empty():
					profiled_presenters += 1
	return {
		"runtime": "2d",
		"revision": 2,
		"direction_count": 8,
		"presentation_zoom": presentation_zoom,
		"ground_vertical_compression": ground_vertical_compression,
		"presenter_count": _presenters.size(),
		"profiled_presenter_count": profiled_presenters,
		"camera_configured": camera != null and is_instance_valid(camera) and _camera_configured_id == camera.get_instance_id(),
		"actor_states": actor_states,
	}
