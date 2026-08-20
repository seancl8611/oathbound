extends Area2D
class_name HubInteractable

## Base class for all hub interaction stations.
## Handles proximity detection, interact popup fade, and menu open/close flow.
## Subclasses override _open_menu() and _on_menu_closed_custom() for their specific UI.

signal interaction_started

var player_near = false
var panel_tween: Tween = null
var menu_opened = false
var player_ref = null

@onready var interact_popup = $InteractPopup

@export var interact_distance: float = 64.0
@export var popup_label_text: String = "Press [E] to Interact"

func _ready():
	interact_popup.visible = false
	interact_popup.modulate.a = 0.0
	_on_ready_custom()

## Override in subclasses for additional setup
func _on_ready_custom():
	pass

func _process(_delta):
	if player_ref:
		var distance = global_position.distance_to(player_ref.global_position)

		if distance > interact_distance:
			if player_near:
				player_near = false
				if not menu_opened:
					hide_interact_popup()
		else:
			if not player_near:
				player_near = true
				if not menu_opened:
					show_interact_popup()

	if player_near and not menu_opened:
		if Input.is_action_just_pressed("interact") and interact_popup.visible:
			_open_menu()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		player_near = true
		if not menu_opened:
			show_interact_popup()

func _on_body_exited(body):
	if body == player_ref:
		player_near = false
		if not menu_opened:
			hide_interact_popup()

# --- Menu Flow ---

## Override this in subclasses to open the station-specific menu/UI.
func _open_menu():
	if menu_opened:
		return
	menu_opened = true
	hide_interact_popup()
	interaction_started.emit()

## Call this from the menu UI when it closes (connect to tree_exited or a custom signal).
func close_menu():
	menu_opened = false
	if player_near:
		show_interact_popup()
	else:
		hide_interact_popup()
	_on_menu_closed_custom()

## Override in subclasses for cleanup after menu closes.
func _on_menu_closed_custom():
	pass

# --- Popup Helpers ---

func show_interact_popup():
	if not is_inside_tree():
		return
	if not is_instance_valid(interact_popup):
		return

	if panel_tween and panel_tween.is_running():
		panel_tween.kill()

	interact_popup.visible = true
	panel_tween = create_tween()
	if panel_tween == null:
		return
	panel_tween.tween_property(interact_popup, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func hide_interact_popup():
	if not is_inside_tree():
		return
	if not is_instance_valid(interact_popup):
		return

	if panel_tween and panel_tween.is_running():
		panel_tween.kill()

	panel_tween = create_tween()
	if panel_tween == null:
		return
	panel_tween.tween_property(interact_popup, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await panel_tween.finished

	if is_instance_valid(interact_popup):
		interact_popup.visible = false
