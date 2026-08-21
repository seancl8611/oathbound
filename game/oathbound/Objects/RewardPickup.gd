extends Area2D

## Hades-style collectible chamber reward.
## `boon` remains accepted only as a compatibility key; player-facing terminology and
## current generation treat that key as a Technique reward.

signal collected

const INTERACT_ACTION := "interact"
const BOB_SPEED := 2.5
const BOB_HEIGHT := 4.0
const TECHNIQUE_UI_SCRIPT = preload("res://Core/Rewards/TechniqueRewardUI.gd")

var reward_key: String = ""
var reward_amount: int = 0
var area_id: int = 1

var _icon: ColorRect
var _glow: ColorRect
var _prompt: Label
var _base_y: float = 0.0
var _time: float = 0.0
var _player_near: bool = false
var _collected: bool = false

const REWARD_COLORS := {
	"gold": Color(0.91, 0.77, 0.29),
	"mist": Color(0.66, 0.48, 0.87),
	"scroll": Color(0.87, 0.78, 0.55),
	"maxhp": Color(0.85, 0.2, 0.15),
	"maxposture": Color(0.87, 0.67, 0.13),
	"boon": Color(0.3, 0.72, 1.0),
	"technique": Color(0.3, 0.72, 1.0),
}

const REWARD_LABELS := {
	"gold": "Gold",
	"mist": "Mist",
	"scroll": "Scrolls",
	"maxhp": "Max Health",
	"maxposture": "Max Posture",
	"boon": "Technique",
	"technique": "Technique",
}


func setup(p_reward_key: String, p_amount: int, p_area_id: int) -> void:
	reward_key = p_reward_key
	reward_amount = p_amount
	area_id = p_area_id


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	monitoring = true

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 24.0
	shape.shape = circle
	add_child(shape)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	_build_visual()
	_base_y = position.y


func _build_visual() -> void:
	var color: Color = REWARD_COLORS.get(reward_key, Color.WHITE)

	_glow = ColorRect.new()
	_glow.size = Vector2(28, 28)
	_glow.position = Vector2(-14, -14)
	_glow.color = Color(color.r, color.g, color.b, 0.2)
	_glow.z_index = 9
	add_child(_glow)

	_icon = ColorRect.new()
	_icon.size = Vector2(16, 16)
	_icon.position = Vector2(-8, -8)
	_icon.color = color
	_icon.z_index = 10
	add_child(_icon)

	var amount_label := Label.new()
	if reward_key in ["boon", "technique"]:
		amount_label.text = "TECHNIQUE"
	else:
		amount_label.text = "+%d" % reward_amount
	amount_label.add_theme_font_size_override("font_size", 11)
	amount_label.add_theme_color_override("font_color", color)
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amount_label.position = Vector2(-32, -28)
	amount_label.size = Vector2(64, 20)
	amount_label.z_index = 11
	add_child(amount_label)

	var type_label := Label.new()
	type_label.text = REWARD_LABELS.get(reward_key, reward_key.capitalize())
	type_label.add_theme_font_size_override("font_size", 9)
	type_label.add_theme_color_override("font_color", Color(color.r, color.g, color.b, 0.7))
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.position = Vector2(-34, 14)
	type_label.size = Vector2(68, 16)
	type_label.z_index = 11
	add_child(type_label)

	_prompt = Label.new()
	_prompt.text = "[E] Collect"
	_prompt.add_theme_font_size_override("font_size", 10)
	_prompt.add_theme_color_override("font_color", Color(0.85, 0.85, 0.88, 0.9))
	_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt.position = Vector2(-30, 30)
	_prompt.size = Vector2(60, 16)
	_prompt.z_index = 11
	_prompt.visible = false
	add_child(_prompt)


func _physics_process(delta: float) -> void:
	if _collected:
		return

	_time += delta
	var bob_offset := sin(_time * BOB_SPEED) * BOB_HEIGHT
	if _icon:
		_icon.position.y = -8.0 + bob_offset
	if _glow:
		_glow.position.y = -14.0 + bob_offset
		_glow.color.a = 0.15 + abs(sin(_time * 1.8)) * 0.15

	if _player_near and Input.is_action_just_pressed(INTERACT_ACTION):
		_collect()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_near = true
		if _prompt:
			_prompt.visible = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_near = false
		if _prompt:
			_prompt.visible = false


func _collect() -> void:
	if _collected:
		return
	_collected = true
	if _prompt:
		_prompt.visible = false

	if reward_key in ["boon", "technique"]:
		await _grant_technique()
	else:
		_grant_currency_or_stat()

	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.25).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	await tween.finished

	collected.emit()
	queue_free()


func _grant_currency_or_stat() -> void:
	var rd := get_node_or_null("/root/RunData")

	match reward_key:
		"gold":
			if rd:
				rd.add_gold(reward_amount)
		"mist":
			if rd:
				rd.add_mist(reward_amount)
		"scroll":
			if rd:
				rd.add_scrolls(reward_amount)
		"maxhp":
			var player := get_tree().get_first_node_in_group("player")
			if player != null and "maxhp" in player:
				player.maxhp += reward_amount
				player.hp = min(player.hp + reward_amount, player.maxhp)
				if player.has_method("_update_health_bar"):
					player._update_health_bar()
		"maxposture":
			var player := get_tree().get_first_node_in_group("player")
			if player != null and "stagger_max" in player:
				player.stagger_max += reward_amount

	_show_hud_toast()
	print("[RewardPickup] Granted: %s x%d" % [reward_key, reward_amount])


func _grant_technique() -> void:
	var technique_ui := TECHNIQUE_UI_SCRIPT.new()
	technique_ui.layer = 100
	technique_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().current_scene.add_child(technique_ui)

	var source := str(get_meta("technique_source", UpgradeService.SOURCE_STANDARD))
	var choices := UpgradeService.get_three_choices_for_source(source, area_id)
	technique_ui.open_with_choices(choices)

	var picked: Dictionary = await technique_ui.choice_made
	UpgradeService.apply_upgrade(picked)
	technique_ui.queue_free()
	print("[RewardPickup] Technique selected from %s: %s" % [source, picked.get("displayname", "?")])


func _show_hud_toast() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	if "run_hud" in player and player.run_hud != null and player.run_hud.has_method("show_currency_toast"):
		player.run_hud.show_currency_toast(reward_key, reward_amount)
