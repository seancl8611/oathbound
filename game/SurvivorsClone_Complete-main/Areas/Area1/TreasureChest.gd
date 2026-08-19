extends Node2D
class_name TreasureChest
signal chest_opened(chest)

const ACTION_INTERACT := "interact"  # bound to E

@export var chest_category_name: String = "Treasure Chest"

@onready var area: Area2D = $Area2D
@onready var prompt: Label = $Prompt
@onready var menu: CanvasLayer = $Menu
@onready var panel: Control = $Menu/Panel
@onready var title_lbl: Label = $Menu/Panel/Label
@onready var claim_btn: Button = $Menu/Panel/ClaimButton

var _locked := true
var _player_inside := false
var _opened := false
var _menu_open := false

# For prompt logic
var _requires_brute_defeat := true
var _permanently_locked := false

# Back-reference to the TreasureRoom (for key checks)
var _treasure_room: Node = null

func _ready() -> void:
	add_to_group("treasure_chest")

	menu.visible = false
	_make_menu_clickable(menu)
	menu.layer = 100  # draw above everything

	title_lbl.text = chest_category_name
	claim_btn.text = "Claim"
	claim_btn.disabled = false
	claim_btn.pressed.connect(_on_claim_pressed)

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	prompt.visible = false

func lock(v: bool) -> void:
	_locked = v
	_update_prompt()

func permanent_lock() -> void:
	_permanently_locked = true
	_locked = true
	_update_prompt()

func on_treasure_key_obtained() -> void:
	# Called by TreasureRoom when brute is defeated
	if _opened:
		return
	_requires_brute_defeat = false
	lock(false)

func _ensure_treasure_room_ref() -> void:
	if _treasure_room == null:
		_treasure_room = get_tree().get_first_node_in_group("treasure_room")

func _unhandled_input(event: InputEvent) -> void:
	if _menu_open or not _player_inside or _opened:
		return

	if event.is_action_pressed(ACTION_INTERACT):
		if _locked:
			return

		_ensure_treasure_room_ref()
		if _treasure_room and _treasure_room.has_method("has_treasure_key"):
			if not _treasure_room.has_treasure_key():
				# Key already used on another chest
				_permanently_locked = true
				_locked = true
				_update_prompt()
				return

		_open_menu()
		get_viewport().set_input_as_handled()

func _on_body_entered(b: Node) -> void:
	if b.is_in_group("player"):
		_player_inside = true
		_update_prompt()

func _on_body_exited(b: Node) -> void:
	if b.is_in_group("player"):
		_player_inside = false
		prompt.visible = false

func _update_prompt() -> void:
	if not _player_inside or _opened:
		prompt.visible = false
		return

	if _locked:
		if _permanently_locked:
			prompt.text = "Locked"
		elif _requires_brute_defeat:
			prompt.text = "Defeat the brute"
		else:
			prompt.text = "Requires a key"
	else:
		prompt.text = "Press [E] to open"

	prompt.visible = true

func _open_menu() -> void:
	_menu_open = true
	menu.visible = true
	_center_panel()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Freeze gameplay without pausing UI
	_set_group_enabled("player", false)
	_set_group_enabled("enemies", false)   # ensure your enemies are in group "enemies"

func _on_claim_pressed() -> void:
	_ensure_treasure_room_ref()

	# Consume the treasure key atomically so only one chest can succeed
	if _treasure_room and _treasure_room.has_method("try_consume_treasure_key"):
		if not _treasure_room.try_consume_treasure_key():
			# Key was already used – close menu and refresh prompt
			_menu_open = false
			menu.visible = false
			_set_group_enabled("player", true)
			_set_group_enabled("enemies", true)
			_permanently_locked = true
			_locked = true
			_update_prompt()
			return

	_opened = true
	_menu_open = false
	menu.visible = false
	prompt.visible = false
	_set_group_enabled("player", true)
	_set_group_enabled("enemies", true)

	emit_signal("chest_opened", self)

# ---------- helpers ----------

func _make_menu_clickable(node: Node) -> void:
	# Ensure mouse works and nothing steals it
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_STOP
	for c in node.get_children():
		_make_menu_clickable(c)

func _center_panel() -> void:
	var vp := get_viewport_rect().size
	var sz := Vector2(360, 160)
	panel.custom_minimum_size = sz
	panel.size = sz
	panel.position = vp * 0.5 - sz * 0.5

func _set_group_enabled(group_name: StringName, enable: bool) -> void:
	var nodes := get_tree().get_nodes_in_group(group_name).duplicate()
	for n in nodes:
		if not is_instance_valid(n):
			continue
		if n.has_method("set_can_move"):
			n.set_can_move(enable)
			continue
		if n is Node:
			if n.has_method("set_process"):
				n.set_process(enable)
			if n.has_method("set_physics_process"):
				n.set_physics_process(enable)
			if n.has_method("set_process_input"):
				n.set_process_input(enable)
			if n.has_method("set_process_unhandled_input"):
				n.set_process_unhandled_input(enable)
