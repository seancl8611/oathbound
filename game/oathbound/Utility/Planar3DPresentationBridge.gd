extends Node

## Live migration bridge from Oathbound's authoritative 2D combat simulation into a
## real-time 3D presentation.
##
## IMPORTANT: this node never moves gameplay actors and never resolves combat. It maps
## each authoritative Node2D ground coordinate (x, y) to Node3D (x, 0, z), mirrors
## facing/action state, and renders a fixed high-angle Camera3D into the existing canvas.
## 2D hitboxes, ranges, Pressure Director behavior, encounter logic and timing remain
## unchanged while we validate the 3D production direction in actual play.
##
## Region-specific presentation belongs in subclasses. The shared bridge deliberately
## knows nothing about Hushiro/Yomori/Kagutsuchi environment implementations; subclasses
## provide environment roots, actor visuals and optional actor decorations through the
## factory hooks below.

@export var enabled: bool = true
@export var pixels_per_meter: float = 64.0
@export var camera_height: float = 10.0
@export var actor_refresh_seconds: float = 0.08
@export var hide_legacy_room_art: bool = true
@export var hide_legacy_actor_art: bool = true
@export var show_debug_label: bool = true

const ACTOR_VISUAL_SCRIPT = preload("res://Utility/Planar3DActorVisual.gd")
const LEGACY_VISIBLE_META := &"_oathbound_planar3d_base_visible"
const KEEP_REPLACEMENT_META := &"oathbound_keep_with_replacement_visual"

var _subviewport: SubViewport = null
var _world_root: Node3D = null
var _camera3d: Camera3D = null
var _environment_root: Node3D = null
var _canvas_layer: CanvasLayer = null
var _texture_rect: TextureRect = null
var _debug_label: Label = null
var _actor_visuals: Dictionary = {}
var _refresh_left: float = 0.0
var _presentation_active: bool = false
var _legacy_static_items: Array[CanvasItem] = []
var _camera2d_settings: Dictionary = {}


func _ready() -> void:
	if not enabled:
		return
	call_deferred("_activate")


func _exit_tree() -> void:
	_restore_legacy_presentation()


func _process(delta: float) -> void:
	if not _presentation_active:
		return
	_sync_viewport_size()
	_sync_camera()

	_refresh_left -= delta
	if _refresh_left <= 0.0:
		_refresh_left = actor_refresh_seconds
		_reconcile_actors()

	_sync_actor_visuals(delta)


func set_presentation_enabled(active: bool) -> void:
	if active == _presentation_active:
		return
	if active:
		_activate()
	else:
		_deactivate()


func is_presentation_enabled() -> bool:
	return _presentation_active


func map_2d_to_3d(world_position: Vector2) -> Vector3:
	var safe_scale := maxf(1.0, pixels_per_meter)
	return Vector3(world_position.x / safe_scale, 0.0, world_position.y / safe_scale)


func _activate() -> void:
	if _presentation_active or not enabled or not is_inside_tree():
		return
	_setup_render_target()
	_setup_world()
	_capture_and_adjust_legacy_camera()
	# Never erase the old room before a region has successfully supplied a replacement
	# environment. This keeps the compatibility presentation visible if a region factory
	# is missing or fails while the shared bridge is being adopted elsewhere.
	if hide_legacy_room_art and _environment_root != null:
		_hide_legacy_room_art()
	_presentation_active = true
	_refresh_left = 0.0
	_reconcile_actors()
	_sync_camera()
	print("[Planar3DPresentationBridge] Live real-time 3D presentation active; 2D combat remains authoritative")


func _deactivate() -> void:
	if not _presentation_active:
		return
	_presentation_active = false
	_restore_legacy_presentation()
	if _canvas_layer != null and is_instance_valid(_canvas_layer):
		_canvas_layer.queue_free()
	if _subviewport != null and is_instance_valid(_subviewport):
		_subviewport.queue_free()
	_canvas_layer = null
	_texture_rect = null
	_debug_label = null
	_subviewport = null
	_world_root = null
	_camera3d = null
	_environment_root = null
	_actor_visuals.clear()


func _setup_render_target() -> void:
	_subviewport = SubViewport.new()
	_subviewport.name = "Planar3DViewport"
	_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_subviewport.transparent_bg = false
	_subviewport.handle_input_locally = false
	add_child(_subviewport)
	_sync_viewport_size()

	_canvas_layer = CanvasLayer.new()
	_canvas_layer.name = "Planar3DCanvas"
	# Render behind the normal 2D world canvas. Existing telegraphs, gates, damage
	# numbers and CanvasLayer HUD remain visible on top during the migration.
	_canvas_layer.layer = -100
	add_child(_canvas_layer)

	_texture_rect = TextureRect.new()
	_texture_rect.name = "Planar3DTexture"
	_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	_canvas_layer.add_child(_texture_rect)
	_texture_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_texture_rect.texture = _subviewport.get_texture()

	if show_debug_label:
		_debug_label = Label.new()
		_debug_label.name = "Planar3DStatus"
		_debug_label.text = "LIVE 3D PRESENTATION • PLANAR COMBAT AUTHORITY"
		_debug_label.position = Vector2(9.0, 332.0)
		_debug_label.add_theme_font_size_override("font_size", 9)
		_debug_label.modulate = Color(0.78, 0.73, 0.66, 0.70)
		_canvas_layer.add_child(_debug_label)


func _setup_world() -> void:
	_world_root = Node3D.new()
	_world_root.name = "Presentation3DWorld"
	_subviewport.add_child(_world_root)

	var world_environment := WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.018, 0.016, 0.018, 1.0)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.24, 0.26, 0.31, 1.0)
	environment.ambient_light_energy = 0.72
	world_environment.environment = environment
	_world_root.add_child(world_environment)

	_environment_root = _create_environment_root()
	if _environment_root != null:
		if str(_environment_root.name).is_empty():
			_environment_root.name = "Presentation3DEnvironment"
		var room := get_parent() as Node2D
		if room != null:
			_environment_root.position = map_2d_to_3d(room.global_position)
		_world_root.add_child(_environment_root)

	_camera3d = Camera3D.new()
	_camera3d.name = "Camera3D"
	_camera3d.projection = Camera3D.PROJECTION_ORTHOGONAL
	_camera3d.near = 0.05
	_camera3d.far = 90.0
	_camera3d.current = true
	_world_root.add_child(_camera3d)


## Region hook. Shared presentation code must not know which environment kit a region uses.
func _create_environment_root() -> Node3D:
	return null


## Region hook. The default bridge uses a generic production-replaceable actor visual.
func _create_actor_visual(_actor: Node2D, _role: String) -> Node3D:
	var visual_value: Variant = ACTOR_VISUAL_SCRIPT.new()
	if visual_value is Node3D:
		return visual_value as Node3D
	return null


## Region hook for presentation-only VFX/accessories that should be children of the
## replacement visual. Combat ownership must remain on the authoritative source actor.
func _decorate_actor_visual(_visual: Node3D, _actor: Node2D, _role: String) -> void:
	pass


func _sync_viewport_size() -> void:
	if _subviewport == null or not is_instance_valid(_subviewport):
		return
	var visible_size := get_viewport().get_visible_rect().size
	var target_size := Vector2i(maxi(1, int(round(visible_size.x))), maxi(1, int(round(visible_size.y))))
	if _subviewport.size != target_size:
		_subviewport.size = target_size


func _sync_camera() -> void:
	if _camera3d == null or not is_instance_valid(_camera3d):
		return
	var camera2d := get_viewport().get_camera_2d()
	var center_2d := Vector2.ZERO
	var zoom := Vector2.ONE
	if camera2d != null:
		center_2d = camera2d.get_screen_center_position()
		zoom = camera2d.zoom
	else:
		var player := _find_player()
		if player != null:
			center_2d = player.global_position

	# Match the existing three-quarter Camera2D projection mathematically. Its X zoom
	# determines world scale while zoom.y / zoom.x determines ground-plane compression.
	# A Camera3D elevation whose sine equals that compression projects X/Z actor feet to
	# the same screen coordinates, allowing existing 2D combat cues to remain aligned.
	var safe_zoom_x := maxf(0.05, absf(zoom.x))
	var ground_projection := clampf(absf(zoom.y) / safe_zoom_x, 0.35, 0.985)
	var elevation := asin(ground_projection)
	var horizontal_offset := camera_height / maxf(0.10, tan(elevation))
	var ground_center := map_2d_to_3d(center_2d)
	_camera3d.global_position = ground_center + Vector3(0.0, camera_height, horizontal_offset)
	_camera3d.look_at(ground_center, Vector3.UP)

	var viewport_height := float(maxi(1, _subviewport.size.y))
	_camera3d.size = viewport_height / (maxf(1.0, pixels_per_meter) * safe_zoom_x)


func _reconcile_actors() -> void:
	var seen: Dictionary = {}
	for actor: Node2D in _presentation_actors():
		var actor_id := actor.get_instance_id()
		seen[actor_id] = true
		var has_visual := _has_valid_actor_visual(actor_id)
		if not has_visual:
			# A replacement may have existed on the previous reconciliation and disappeared
			# since then. Restore the authoritative body before attempting a rebuild so a
			# failed resource/model rebuild can never strand a live actor invisible.
			_restore_actor_art(actor)
			_add_actor_visual(actor)
			has_visual = _has_valid_actor_visual(actor_id)

		if hide_legacy_actor_art and has_visual:
			_hide_actor_art(actor)
		else:
			# This also makes toggling exclusive replacement off at runtime reversible.
			_restore_actor_art(actor)

	for actor_id: Variant in _actor_visuals.keys():
		if seen.has(actor_id):
			continue
		var visual_value: Variant = _actor_visuals.get(actor_id)
		if visual_value is Node and is_instance_valid(visual_value as Node):
			var source_value: Variant = (visual_value as Node).get("source_actor")
			if source_value is Node2D and is_instance_valid(source_value as Node2D):
				_restore_actor_art(source_value as Node2D)
			(visual_value as Node).queue_free()
		_actor_visuals.erase(actor_id)


func _has_valid_actor_visual(actor_id: Variant) -> bool:
	if not _actor_visuals.has(actor_id):
		return false
	var visual_value: Variant = _actor_visuals.get(actor_id)
	if visual_value is Node3D and is_instance_valid(visual_value as Node3D):
		return true
	_actor_visuals.erase(actor_id)
	return false


func _add_actor_visual(actor: Node2D) -> void:
	if _world_root == null:
		return
	var role := _role_for(actor)
	var visual := _create_actor_visual(actor, role)
	if visual == null:
		return
	visual.name = "Actor3D_%s" % str(actor.get_instance_id())
	_world_root.add_child(visual)
	if visual.has_method("configure"):
		visual.call("configure", role, actor)
	_decorate_actor_visual(visual, actor, role)
	_actor_visuals[actor.get_instance_id()] = visual


func _sync_actor_visuals(delta: float) -> void:
	for actor_id: Variant in _actor_visuals.keys():
		var visual_value: Variant = _actor_visuals.get(actor_id)
		if not (visual_value is Node3D) or not is_instance_valid(visual_value as Node3D):
			continue
		var visual := visual_value as Node3D
		var source_value: Variant = visual.get("source_actor")
		if not (source_value is Node2D) or not is_instance_valid(source_value as Node2D):
			continue
		var source := source_value as Node2D
		visual.position = map_2d_to_3d(source.global_position)
		if visual.has_method("sync_from_source"):
			visual.call("sync_from_source", delta)


func _presentation_actors() -> Array[Node2D]:
	var actors: Array[Node2D] = []
	var tree := get_tree()
	if tree == null:
		return actors
	var room := get_parent()
	for group_name: StringName in [&"player", &"enemy"]:
		for candidate: Node in tree.get_nodes_in_group(group_name):
			if not (is_instance_valid(candidate) and candidate is Node2D):
				continue
			if group_name == &"enemy" and room != null and not room.is_ancestor_of(candidate):
				continue
			actors.append(candidate as Node2D)
	return actors


func _find_player() -> Node2D:
	var tree := get_tree()
	if tree == null:
		return null
	var player := tree.get_first_node_in_group("player")
	return player as Node2D if player is Node2D else null


func _role_for(actor: Node2D) -> String:
	if actor.is_in_group("player"):
		return "player"

	# `presentation_role` is the region-neutral presentation identity contract. Preserve
	# arbitrary semantic roles (archer, warden, controller, future regional roles, etc.)
	# rather than collapsing every non-Swordsman/Hound actor into generic `enemy`.
	var presentation_role := str(actor.get_meta(&"presentation_role", "")).strip_edges().to_lower()
	if not presentation_role.is_empty():
		return presentation_role

	# `enemy_type` is a shared compatibility fallback used by some non-Hushiro actors.
	var enemy_type := str(actor.get_meta(&"enemy_type", "")).strip_edges().to_lower()
	if not enemy_type.is_empty():
		return enemy_type

	# Hushiro's old metadata key remains only as a migration fallback. New Hushiro
	# standard enemies publish presentation_role through HushiroEnemyContract.
	var hushiro_enemy_type := str(actor.get_meta(&"hushiro_enemy_type", "")).strip_edges().to_lower()
	if not hushiro_enemy_type.is_empty():
		return hushiro_enemy_type

	# Last-resort name/script inference exists only for legacy actors that have not yet
	# been normalized by a region contract.
	var identity := str(actor.name).to_lower()
	var script_value: Variant = actor.get_script()
	if script_value is Script:
		identity += " " + (script_value as Script).resource_path.to_lower()
	if identity.contains("swordsman"):
		return "swordsman"
	if identity.contains("hound") or identity.contains("dog"):
		return "hound"
	return "enemy"


func _hide_legacy_room_art() -> void:
	var room := get_parent()
	if room == null:
		return
	for path: NodePath in [NodePath("Background"), NodePath("ThreeQuarterPresentation/Scenery")]:
		var item := room.get_node_or_null(path) as CanvasItem
		if item != null:
			_remember_and_hide(item)


func _hide_actor_art(actor: Node2D) -> void:
	_hide_actor_art_recursive(actor, actor)


func _hide_actor_art_recursive(root: Node2D, node: Node) -> void:
	if node != root and bool(node.get_meta(KEEP_REPLACEMENT_META, false)):
		return
	if node != root and node is CanvasItem:
		var item := node as CanvasItem
		var is_body_art := node is Sprite2D or node is AnimatedSprite2D or node is Polygon2D
		var is_legacy_proxy := node.name in [&"ThreeQuarterActorProxy", &"ThreeQuarterGroundShadow"]
		if is_body_art or is_legacy_proxy:
			_remember_and_hide(item)
	for child: Node in node.get_children():
		_hide_actor_art_recursive(root, child)


func _restore_actor_art(actor: Node2D) -> void:
	_restore_actor_art_recursive(actor, actor)


func _restore_actor_art_recursive(root: Node2D, node: Node) -> void:
	if node != root and bool(node.get_meta(KEEP_REPLACEMENT_META, false)):
		return
	if node != root and node is CanvasItem:
		var item := node as CanvasItem
		if item.has_meta(LEGACY_VISIBLE_META):
			item.visible = bool(item.get_meta(LEGACY_VISIBLE_META))
			item.remove_meta(LEGACY_VISIBLE_META)
			_legacy_static_items.erase(item)
	for child: Node in node.get_children():
		_restore_actor_art_recursive(root, child)


func _remember_and_hide(item: CanvasItem) -> void:
	if not item.has_meta(LEGACY_VISIBLE_META):
		item.set_meta(LEGACY_VISIBLE_META, item.visible)
		_legacy_static_items.append(item)
	item.visible = false


func _capture_and_adjust_legacy_camera() -> void:
	var camera2d := get_viewport().get_camera_2d()
	if camera2d == null:
		return
	for property_name: String in ["use_procedural_actor_proxies", "add_contact_shadows"]:
		if not _has_property(camera2d, property_name):
			continue
		_camera2d_settings[property_name] = camera2d.get(property_name)
		camera2d.set(property_name, false)


func _restore_legacy_presentation() -> void:
	for item: CanvasItem in _legacy_static_items:
		if item != null and is_instance_valid(item) and item.has_meta(LEGACY_VISIBLE_META):
			item.visible = bool(item.get_meta(LEGACY_VISIBLE_META))
			item.remove_meta(LEGACY_VISIBLE_META)
	_legacy_static_items.clear()

	var camera2d := get_viewport().get_camera_2d() if is_inside_tree() else null
	if camera2d != null:
		for property_name: Variant in _camera2d_settings.keys():
			if _has_property(camera2d, str(property_name)):
				camera2d.set(str(property_name), _camera2d_settings[property_name])
	_camera2d_settings.clear()


func _has_property(object: Object, property_name: String) -> bool:
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			return true
	return false
