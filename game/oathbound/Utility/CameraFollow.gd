extends Camera2D

## Player-follow camera plus the adopted three-quarter presentation.
##
## The simulation remains completely 2D. We project the ground plane by using a
## non-uniform Camera2D zoom (Y is compressed relative to X), then counter-scale the
## main character sprites/proxies and world-space interface so upright content is not
## squashed. Physics, navigation, hitboxes, attack ranges and AI stay authoritative in
## their existing world coordinates.

@export_category("Follow")
@export var smoothing_on_start := true
@export var smoothing_speed := 8.0

@export_category("Three-quarter presentation")
@export var three_quarter_enabled := true
# The adopted profile uses a gentler projection than the first stretch-test. Authored
# room dressing and actor silhouettes carry most of the depth read instead of severe Y squash.
@export_range(0.5, 1.5, 0.01) var presentation_zoom := 0.94
@export_range(0.5, 1.0, 0.01) var ground_vertical_compression := 0.84
@export var framing_world_offset := Vector2(0.0, -18.0)
@export var compensate_character_sprites := true
@export_range(0.0, 1.0, 0.05) var sprite_counter_projection := 1.0
@export var compensate_world_controls := true
@export var use_procedural_actor_proxies := true
@export var hide_legacy_actor_sprites_when_proxying := true
@export var add_contact_shadows := true
@export var depth_sort_characters := true
# Developer-only A/B badge. F9 remains available for regression comparison, but the
# adopted three-quarter view should not advertise itself as a prototype during normal play.
@export var show_prototype_badge := false
@export var toggle_key: Key = KEY_F9
@export_range(0.05, 1.0, 0.05) var actor_refresh_seconds := 0.20

const ACTOR_PROXY_SCRIPT = preload("res://Utility/ThreeQuarterActorProxy.gd")
const PRESENTATION_SCALE_META := &"_oathbound_three_quarter_base_scale"
const PRESENTATION_Z_META := &"_oathbound_three_quarter_base_z"
const PRESENTATION_SELF_MODULATE_META := &"_oathbound_three_quarter_base_self_modulate"
const PRESENTATION_WORLD_UI_SCALE_META := &"_oathbound_three_quarter_world_ui_scale"
const PRESENTATION_SHADOW_PENDING_META := &"_oathbound_three_quarter_shadow_pending"
const PRESENTATION_PROXY_PENDING_META := &"_oathbound_three_quarter_proxy_pending"
const PRESENTATION_SHADOW_NAME := &"ThreeQuarterGroundShadow"
const PRESENTATION_PROXY_NAME := &"ThreeQuarterActorProxy"
# Existing scenes were authored before world-depth sorting and often leave backgrounds
# at z=0. Bias projected actors above that legacy floor, then sort actors against one
# another by Y. Future three-quarter props can opt into explicit foreground Z bands.
const ACTOR_DEPTH_BIAS := 1000
const DEPTH_Z_MIN := -4095
const DEPTH_Z_MAX := 4095

var _target: Node2D
var _base_zoom := Vector2.ONE
var _active_three_quarter := false
var _actor_refresh_left := 0.0
var _prototype_badge: Label = null


func _ready() -> void:
	_target = get_parent() as Node2D
	_base_zoom = zoom
	_active_three_quarter = three_quarter_enabled

	# Snap before enabling smoothing/current to avoid the initial slide.
	_snap_follow_position()
	make_current()
	position_smoothing_enabled = smoothing_on_start
	position_smoothing_speed = smoothing_speed

	_apply_presentation_profile()
	_ensure_prototype_badge()


func _exit_tree() -> void:
	# Do not leave actor/UI visuals mutated if this Camera2D is removed while the scene
	# survives a transition/debug reload.
	_restore_all_actor_visuals()


func _physics_process(dt: float) -> void:
	_snap_follow_position()

	if not _active_three_quarter:
		return

	_actor_refresh_left -= dt
	if _actor_refresh_left <= 0.0:
		_actor_refresh_left = actor_refresh_seconds
		_refresh_actor_presentation()

	if depth_sort_characters:
		_update_actor_depth_order()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode != toggle_key and key_event.physical_keycode != toggle_key:
		return

	_set_three_quarter_active(not _active_three_quarter)
	get_viewport().set_input_as_handled()


# Optional helpers so rooms can control timing.
func snap_to_target() -> void:
	_snap_follow_position()


func set_smoothing_enabled(on: bool) -> void:
	position_smoothing_enabled = on


func set_three_quarter_enabled(on: bool) -> void:
	_set_three_quarter_active(on)


func is_three_quarter_enabled() -> bool:
	return _active_three_quarter


func _snap_follow_position() -> void:
	if _target == null:
		return
	var follow_offset := framing_world_offset if _active_three_quarter else Vector2.ZERO
	global_position = _target.global_position + follow_offset


func _set_three_quarter_active(on: bool) -> void:
	if _active_three_quarter == on:
		_apply_presentation_profile()
		return

	_active_three_quarter = on
	if not _active_three_quarter:
		_restore_all_actor_visuals()
	_apply_presentation_profile()
	_snap_follow_position()
	_actor_refresh_left = 0.0
	_update_badge_text()


func _apply_presentation_profile() -> void:
	if _active_three_quarter:
		var safe_compression := maxf(0.01, ground_vertical_compression)
		zoom = Vector2(presentation_zoom, presentation_zoom * safe_compression)
		_refresh_actor_presentation()
	else:
		zoom = _base_zoom
	_update_badge_text()


func _refresh_actor_presentation() -> void:
	if not _active_three_quarter:
		return
	for actor: Node in _presentation_actors():
		_prepare_actor_visual(actor)
	if compensate_world_controls:
		_refresh_world_controls()


func _presentation_actors() -> Array[Node]:
	var actors: Array[Node] = []
	var tree := get_tree()
	if tree == null:
		return actors

	for group_name: StringName in [&"player", &"enemy"]:
		for candidate: Node in tree.get_nodes_in_group(group_name):
			if is_instance_valid(candidate) and candidate is Node2D:
				actors.append(candidate)
	return actors


func _prepare_actor_visual(actor: Node) -> void:
	if not (actor is Node2D):
		return
	var actor_2d := actor as Node2D

	if depth_sort_characters and not actor_2d.has_meta(PRESENTATION_Z_META):
		actor_2d.set_meta(PRESENTATION_Z_META, actor_2d.z_index)

	var sprite := _find_main_actor_sprite(actor_2d)
	if sprite != null:
		if compensate_character_sprites:
			if not sprite.has_meta(PRESENTATION_SCALE_META):
				sprite.set_meta(PRESENTATION_SCALE_META, sprite.scale)
			var base_scale_value: Variant = sprite.get_meta(PRESENTATION_SCALE_META)
			if base_scale_value is Vector2:
				var base_scale: Vector2 = base_scale_value
				var safe_compression := maxf(0.01, ground_vertical_compression)
				# Counter-project only the body artwork. The interpolation knob lets us reduce
				# correction if compatibility sprites feel too tall.
				var target_y_factor := 1.0 / safe_compression
				var y_factor := lerpf(1.0, target_y_factor, clampf(sprite_counter_projection, 0.0, 1.0))
				sprite.scale = Vector2(base_scale.x, base_scale.y * y_factor)

		if use_procedural_actor_proxies and hide_legacy_actor_sprites_when_proxying:
			if not sprite.has_meta(PRESENTATION_SELF_MODULATE_META):
				sprite.set_meta(PRESENTATION_SELF_MODULATE_META, sprite.self_modulate)
			var hidden_color := sprite.self_modulate
			hidden_color.a = 0.0
			sprite.self_modulate = hidden_color

	if add_contact_shadows:
		_ensure_contact_shadow(actor_2d, sprite)
	if use_procedural_actor_proxies:
		_ensure_actor_proxy(actor_2d)


func _refresh_world_controls() -> void:
	# CanvasLayer HUD is already screen-space and must never be counter-projected. Only
	# top-level Control roots living in the same world tree as the Player/current room are
	# adjusted; child Controls inherit that transform once instead of being double-scaled.
	if _target == null:
		return
	var world_root := _target.get_parent()
	if world_root == null:
		return
	_prepare_world_controls_recursive(world_root, false)


func _prepare_world_controls_recursive(node: Node, inside_canvas_layer: bool) -> void:
	var now_inside_canvas_layer := inside_canvas_layer or node is CanvasLayer
	if node is Control and not now_inside_canvas_layer:
		var control := node as Control
		if not control.has_meta(PRESENTATION_WORLD_UI_SCALE_META):
			control.set_meta(PRESENTATION_WORLD_UI_SCALE_META, control.scale)
		var base_scale_value: Variant = control.get_meta(PRESENTATION_WORLD_UI_SCALE_META)
		if base_scale_value is Vector2:
			var base_scale: Vector2 = base_scale_value
			var safe_compression := maxf(0.01, ground_vertical_compression)
			control.scale = Vector2(base_scale.x, base_scale.y / safe_compression)
		# Descendant Controls inherit the corrected transform from this root. Recursing
		# into them would apply the inverse compression multiple times.
		return

	for child: Node in node.get_children():
		_prepare_world_controls_recursive(child, now_inside_canvas_layer)


func _restore_world_controls() -> void:
	if _target == null:
		return
	var world_root := _target.get_parent()
	if world_root == null:
		return
	_restore_world_controls_recursive(world_root, false)


func _restore_world_controls_recursive(node: Node, inside_canvas_layer: bool) -> void:
	var now_inside_canvas_layer := inside_canvas_layer or node is CanvasLayer
	if node is Control and not now_inside_canvas_layer:
		var control := node as Control
		if control.has_meta(PRESENTATION_WORLD_UI_SCALE_META):
			var base_scale_value: Variant = control.get_meta(PRESENTATION_WORLD_UI_SCALE_META)
			if base_scale_value is Vector2:
				control.scale = base_scale_value
		return

	for child: Node in node.get_children():
		_restore_world_controls_recursive(child, now_inside_canvas_layer)


func _restore_all_actor_visuals() -> void:
	for actor: Node in _presentation_actors():
		if not (actor is Node2D):
			continue
		var actor_2d := actor as Node2D
		var sprite := _find_main_actor_sprite(actor_2d)
		if sprite != null:
			if sprite.has_meta(PRESENTATION_SCALE_META):
				var base_scale_value: Variant = sprite.get_meta(PRESENTATION_SCALE_META)
				if base_scale_value is Vector2:
					sprite.scale = base_scale_value
			if sprite.has_meta(PRESENTATION_SELF_MODULATE_META):
				var base_modulate_value: Variant = sprite.get_meta(PRESENTATION_SELF_MODULATE_META)
				if base_modulate_value is Color:
					sprite.self_modulate = base_modulate_value

		if actor_2d.has_meta(PRESENTATION_Z_META):
			actor_2d.z_index = int(actor_2d.get_meta(PRESENTATION_Z_META))

		actor_2d.remove_meta(PRESENTATION_SHADOW_PENDING_META)
		actor_2d.remove_meta(PRESENTATION_PROXY_PENDING_META)
		var shadow := actor_2d.get_node_or_null(NodePath(str(PRESENTATION_SHADOW_NAME)))
		if shadow != null:
			shadow.queue_free()
		var proxy := actor_2d.get_node_or_null(NodePath(str(PRESENTATION_PROXY_NAME)))
		if proxy != null:
			proxy.queue_free()

	_restore_world_controls()


func _find_main_actor_sprite(actor: Node2D) -> Sprite2D:
	# Current Akio and migrated standard enemies generally use a direct Sprite2D named
	# Sprite2D. The fallback keeps the presentation useful for compatibility actors.
	var direct := actor.get_node_or_null("Sprite2D") as Sprite2D
	if direct != null:
		return direct

	for child: Node in actor.get_children():
		if child is Sprite2D:
			return child as Sprite2D
	return null


func _ensure_actor_proxy(actor: Node2D) -> void:
	var existing := actor.get_node_or_null(NodePath(str(PRESENTATION_PROXY_NAME)))
	if existing != null:
		if existing.has_method("configure"):
			existing.call("configure", ground_vertical_compression)
		return
	if bool(actor.get_meta(PRESENTATION_PROXY_PENDING_META, false)):
		return

	var proxy := Node2D.new()
	proxy.name = str(PRESENTATION_PROXY_NAME)
	proxy.set_script(ACTOR_PROXY_SCRIPT)
	proxy.z_index = 2
	actor.set_meta(PRESENTATION_PROXY_PENDING_META, true)
	_attach_actor_proxy_deferred.call_deferred(actor, proxy)


func _attach_actor_proxy_deferred(actor: Node2D, proxy: Node2D) -> void:
	if not is_instance_valid(actor):
		if is_instance_valid(proxy):
			proxy.queue_free()
		return

	actor.remove_meta(PRESENTATION_PROXY_PENDING_META)
	if not _active_three_quarter or not use_procedural_actor_proxies:
		if is_instance_valid(proxy):
			proxy.queue_free()
		return
	if actor.has_node(NodePath(str(PRESENTATION_PROXY_NAME))):
		if is_instance_valid(proxy):
			proxy.queue_free()
		return
	actor.add_child(proxy)
	if proxy.has_method("configure"):
		proxy.call("configure", ground_vertical_compression)


func _ensure_contact_shadow(actor: Node2D, sprite: Sprite2D) -> void:
	if actor.has_node(NodePath(str(PRESENTATION_SHADOW_NAME))):
		return
	if bool(actor.get_meta(PRESENTATION_SHADOW_PENDING_META, false)):
		return

	var radius_x := 11.0
	if sprite != null and sprite.texture != null:
		radius_x = clampf(float(sprite.texture.get_width()) * absf(sprite.scale.x) * 0.16, 8.0, 18.0)
	var radius_y := radius_x * 0.50

	var points := PackedVector2Array()
	for index: int in range(20):
		var angle := TAU * float(index) / 20.0
		points.append(Vector2(cos(angle) * radius_x, sin(angle) * radius_y))

	var shadow := Polygon2D.new()
	shadow.name = str(PRESENTATION_SHADOW_NAME)
	shadow.polygon = points
	shadow.color = Color(0.035, 0.025, 0.025, 0.28)
	shadow.position = Vector2(0.0, 5.0)
	shadow.z_index = -1
	shadow.show_behind_parent = true

	# CameraFollow can enter _ready() while GameFlow is still attaching the room/player
	# hierarchy. Godot correctly rejects add_child() while that parent is busy. Mark this
	# actor as pending and attach on the next safe idle turn instead.
	actor.set_meta(PRESENTATION_SHADOW_PENDING_META, true)
	_attach_contact_shadow_deferred.call_deferred(actor, shadow)


func _attach_contact_shadow_deferred(actor: Node2D, shadow: Polygon2D) -> void:
	if not is_instance_valid(actor):
		if is_instance_valid(shadow):
			shadow.queue_free()
		return

	actor.remove_meta(PRESENTATION_SHADOW_PENDING_META)
	if not _active_three_quarter or not add_contact_shadows:
		if is_instance_valid(shadow):
			shadow.queue_free()
		return
	if actor.has_node(NodePath(str(PRESENTATION_SHADOW_NAME))):
		if is_instance_valid(shadow):
			shadow.queue_free()
		return
	actor.add_child(shadow)


func _update_actor_depth_order() -> void:
	for actor: Node in _presentation_actors():
		if not (actor is Node2D):
			continue
		var actor_2d := actor as Node2D
		if not actor_2d.has_meta(PRESENTATION_Z_META):
			actor_2d.set_meta(PRESENTATION_Z_META, actor_2d.z_index)
		var base_z := int(actor_2d.get_meta(PRESENTATION_Z_META))
		var projected_z := ACTOR_DEPTH_BIAS + base_z + int(round(actor_2d.global_position.y))
		actor_2d.z_index = clampi(projected_z, DEPTH_Z_MIN, DEPTH_Z_MAX)


func _ensure_prototype_badge() -> void:
	if not show_prototype_badge:
		return
	var layer := CanvasLayer.new()
	layer.name = "ThreeQuarterDebugHUD"
	layer.layer = 90
	add_child(layer)

	_prototype_badge = Label.new()
	_prototype_badge.name = "ModeBadge"
	_prototype_badge.position = Vector2(14.0, 12.0)
	_prototype_badge.add_theme_font_size_override("font_size", 13)
	_prototype_badge.add_theme_color_override("font_color", Color(0.93, 0.91, 0.84, 0.88))
	_prototype_badge.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	_prototype_badge.add_theme_constant_override("shadow_offset_x", 1)
	_prototype_badge.add_theme_constant_override("shadow_offset_y", 1)
	layer.add_child(_prototype_badge)
	_update_badge_text()


func _update_badge_text() -> void:
	if _prototype_badge == null:
		return
	if _active_three_quarter:
		_prototype_badge.text = "THREE-QUARTER POV  |  F9: legacy debug view"
	else:
		_prototype_badge.text = "LEGACY DEBUG VIEW  |  F9: three-quarter POV"
