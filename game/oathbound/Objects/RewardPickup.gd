extends Area2D

## =============================================================================
## REWARD PICKUP — Hades-style collectible room reward
## =============================================================================
## Spawns after room clear. Player walks up and presses interact to collect.
## Built entirely through code — no scene file needed.
##
## Usage:
##   var pickup = RewardPickup.new()
##   pickup.setup("mist", 4, 1)  # reward_key, amount, area_id
##   pickup.global_position = some_pos
##   some_parent.add_child(pickup)
##   await pickup.collected   # optional: wait for collection
## =============================================================================

signal collected

const INTERACT_ACTION = "interact"
const BOB_SPEED = 2.5
const BOB_HEIGHT = 4.0

# ─── Reward data ───
var reward_key: String = ""
var reward_amount: int = 0
var area_id: int = 1

# ─── Visual refs ───
var _icon: ColorRect
var _glow: ColorRect
var _prompt: Label
var _base_y: float = 0.0
var _time: float = 0.0
var _player_near: bool = false
var _collected: bool = false

# ─── Boon UI ref (for boon pickups) ───
var _upgrade_ui: Node = null

# ─── Colors per reward type ───
const REWARD_COLORS = {
	"gold":        Color(0.91, 0.77, 0.29),
	"mist":        Color(0.66, 0.48, 0.87),
	"scroll":      Color(0.87, 0.78, 0.55),
	"maxhp":       Color(0.85, 0.2, 0.15),
	"maxposture":  Color(0.87, 0.67, 0.13),
	"boon":        Color(0.3, 0.72, 1.0),
}

const REWARD_LABELS = {
	"gold":        "Gold",
	"mist":        "Mist Shards",
	"scroll":      "Scrolls",
	"maxhp":       "Max HP",
	"maxposture":  "Max Posture",
	"boon":        "Boon",
}


func setup(p_reward_key: String, p_amount: int, p_area_id: int) -> void:
	reward_key = p_reward_key
	reward_amount = p_amount
	area_id = p_area_id

func _ready() -> void:
	# Collision setup — detect player body (CharacterBody2D on layer 1)
	collision_layer = 0
	collision_mask = 1  # Player CharacterBody2D is on layer 1
	monitoring = true
	
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 24.0
	shape.shape = circle
	add_child(shape)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_build_visual()
	_base_y = position.y
	
func _build_visual() -> void:
	var color = REWARD_COLORS.get(reward_key, Color.WHITE)
	
	# Glow behind icon
	_glow = ColorRect.new()
	_glow.size = Vector2(28, 28)
	_glow.position = Vector2(-14, -14)
	_glow.color = Color(color.r, color.g, color.b, 0.2)
	_glow.z_index = 9
	add_child(_glow)
	
	# Icon square
	_icon = ColorRect.new()
	_icon.size = Vector2(16, 16)
	_icon.position = Vector2(-8, -8)
	_icon.color = color
	_icon.z_index = 10
	add_child(_icon)
	
	# Amount label above icon
	var amount_label = Label.new()
	if reward_key == "boon":
		amount_label.text = "BOON"
	else:
		amount_label.text = "+%d" % reward_amount
	amount_label.add_theme_font_size_override("font_size", 11)
	amount_label.add_theme_color_override("font_color", color)
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amount_label.position = Vector2(-20, -28)
	amount_label.size = Vector2(40, 20)
	amount_label.z_index = 11
	add_child(amount_label)
	
	# Type label below icon
	var type_label = Label.new()
	type_label.text = REWARD_LABELS.get(reward_key, reward_key.capitalize())
	type_label.add_theme_font_size_override("font_size", 9)
	type_label.add_theme_color_override("font_color", Color(color.r, color.g, color.b, 0.7))
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.position = Vector2(-30, 14)
	type_label.size = Vector2(60, 16)
	type_label.z_index = 11
	add_child(type_label)
	
	# Interact prompt (hidden until near)
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
	
	# Bob animation
	_time += delta
	var bob_offset = sin(_time * BOB_SPEED) * BOB_HEIGHT
	if _icon:
		_icon.position.y = -8.0 + bob_offset
	if _glow:
		_glow.position.y = -14.0 + bob_offset
	
	# Glow pulse
	if _glow:
		var pulse = 0.15 + abs(sin(_time * 1.8)) * 0.15
		_glow.color.a = pulse
	
	# Interact check
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
	
	# Grant the reward
	if reward_key == "boon":
		await _grant_boon()
	else:
		_grant_currency_or_stat()
	
	# Collect animation — scale down and fade
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2(0.1, 0.1), 0.25).set_ease(Tween.EASE_IN)
	tw.tween_property(self, "modulate:a", 0.0, 0.25)
	await tw.finished
	
	emit_signal("collected")
	queue_free()


func _grant_currency_or_stat() -> void:
	var rd = get_node_or_null("/root/RunData")
	
	match reward_key:
		"gold":
			if rd:
				rd.add_gold(reward_amount)
		"mist":
			if rd:
				rd.add_mist_shards(reward_amount)
		"scroll":
			if rd:
				rd.add_scrolls(reward_amount)
		"maxhp":
			var players = get_tree().get_nodes_in_group("player")
			if players.size() > 0:
				var p = players[0]
				if "maxhp" in p:
					p.maxhp += reward_amount
					p.hp = min(p.hp + reward_amount, p.maxhp)
					if p.has_method("_update_health_bar"):
						p._update_health_bar()
		"maxposture":
			var players = get_tree().get_nodes_in_group("player")
			if players.size() > 0:
				var p = players[0]
				if "stagger_max" in p:
					p.stagger_max += reward_amount
	
	# Show toast on RunHUD
	_show_hud_toast()
	
	print("[RewardPickup] Granted: %s x%d" % [reward_key, reward_amount])


func _grant_boon() -> void:
	var upgrade_ui = get_tree().get_first_node_in_group("upgrade_ui")
	if upgrade_ui == null:
		var ui_scene = preload("res://Utility/UpgradeChoiceUI.tscn")
		upgrade_ui = ui_scene.instantiate()
		upgrade_ui.add_to_group("upgrade_ui")
		upgrade_ui.layer = 100
		upgrade_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		get_tree().current_scene.add_child(upgrade_ui)
	
	var choices = UpgradeService.get_three_choices()
	upgrade_ui.visible = true
	upgrade_ui.open_with_choices(choices)
	
	var picked = await upgrade_ui.choice_made
	UpgradeService.apply_upgrade(picked)
	upgrade_ui.visible = false
	print("[RewardPickup] Boon selected: %s" % picked.get("displayname", "?"))


func _show_hud_toast() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	var p = players[0]
	if "run_hud" in p and p.run_hud != null and p.run_hud.has_method("show_currency_toast"):
		p.run_hud.show_currency_toast(reward_key, reward_amount)
