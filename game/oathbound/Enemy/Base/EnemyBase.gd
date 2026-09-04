extends CharacterBody2D
class_name EnemyBase

## =============================================================================
## ENEMY BASE
## =============================================================================
## Universal parent class for all enemies, minibosses, and bosses.
##
## =============================================================================

signal enemy_died(enemy: Node)
signal enemy_posture_broken(enemy: Node, duration: float)
signal enemy_received_hit(enemy: Node, event: Dictionary)

var enemy_base_initialized: bool = false
var _base_combat_signals_connected: bool = false
var _base_hurtbox_signals_connected: bool = false

# =============================================================================
# SHARED CORE STATS
# =============================================================================

@export_group("Core Stats")
@export var movement_speed: float = 55.0
@export var hp: int = 200
@export var experience: int = 1
@export var enemy_damage: int = 1
@export var enemy_tags: Array = []

var _max_hp: int = 0
var has_died: bool = false
var _pending_hp_damage_display: bool = false
var _last_applied_hp_damage: int = 0

# =============================================================================
# SHARED NODE REFERENCES
# =============================================================================
@onready var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D") as Sprite2D
@onready var anim: AnimationPlayer = get_node_or_null("AnimationPlayer") as AnimationPlayer
@onready var hurt_box: Area2D = get_node_or_null("HurtBox") as Area2D
@onready var combat: CombatController = get_node_or_null("Combat") as CombatController

# =============================================================================
# UNIVERSAL COMBAT RUNTIME
# =============================================================================

@export var knockback_recovery: float = 5.0

var knockback: Vector2 = Vector2.ZERO

# =============================================================================
# SHARED ATTACK DIRECTOR STATE
# =============================================================================

var has_attack_token: bool = false
var _held_roles: Dictionary = {}

var _hitstop_until: float = -1.0
var _hitstop_anim_paused: bool = false
var _hitstop_saved_speed: float = 1.0

# =============================================================================
# SHARED POSTURE UI
# =============================================================================

var _posture_ui: Node2D
var _posture_bg: ColorRect
var _posture_fill: ColorRect

func _base_enemy_ready() -> void:
	enemy_base_initialized = true
	
	if not is_in_group("enemy"):
		add_to_group("enemy")
	
	if _max_hp <= 0:
		_max_hp = hp
	
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
	
	if sprite == null:
		sprite = get_node_or_null("Sprite2D") as Sprite2D
	
	if anim == null:
		anim = get_node_or_null("AnimationPlayer") as AnimationPlayer
	
	if hurt_box == null:
		hurt_box = get_node_or_null("HurtBox") as Area2D
	
	if combat == null:
		combat = get_node_or_null("Combat") as CombatController
	
	_setup_posture_bar()
	_connect_base_hurtbox_signals()
	_connect_base_combat_signals()

func is_enemy_base() -> bool:
	return true


func get_enemy_root() -> Node:
	return self


func get_hurtbox_node() -> Node:
	if hurt_box:
		return hurt_box
	return get_node_or_null("HurtBox")


func get_combat_node() -> Node:
	if combat:
		return combat
	return get_node_or_null("Combat")


func get_animation_node() -> AnimationPlayer:
	if anim:
		return anim
	
	var node = get_node_or_null("AnimationPlayer")
	if node is AnimationPlayer:
		return node
	
	return null

func get_sprite_node() -> CanvasItem:
	if sprite:
		return sprite
	
	var node = get_node_or_null("Sprite2D")
	if node is CanvasItem:
		return node
	
	return null

# =============================================================================
# SHARED COMBAT / POSTURE SIGNAL HOOKUP
# =============================================================================

func _connect_base_combat_signals() -> void:
	if _base_combat_signals_connected:
		return
	
	if combat == null:
		return
	
	_base_combat_signals_connected = true
	
	if combat.has_signal("posture_broken"):
		combat.posture_broken.connect(func(dur: float):
			_forward_deathblow_available(dur)
			_on_base_posture_broken(dur)
		)
	
	if combat.has_signal("posture_changed"):
		combat.posture_changed.connect(func(cur: float, maxv: float):
			_update_posture_bar(cur, maxv)
			
			if maxv > 0.0 and cur >= maxv - 0.001:
				_on_base_posture_meter_filled()
		)

func _connect_base_hurtbox_signals() -> void:
	if _base_hurtbox_signals_connected:
		return
	
	if hurt_box == null:
		return
	
	if not hurt_box.has_signal("hurt"):
		return
	
	var cb := Callable(self, "_on_hurt_box_hurt")
	if has_method("_on_hurt_box_hurt") and not hurt_box.is_connected("hurt", cb):
		hurt_box.connect("hurt", cb)
	
	_base_hurtbox_signals_connected = true
	
func _forward_deathblow_available(duration: float) -> void:
	var p = get_player_ref()
	if not p:
		return
	
	if not p.has_node("Combat"):
		return
	
	var pc = p.get_node("Combat")
	if pc == null:
		return
	
	if pc.has_method("set_deathblow_target"):
		pc.set_deathblow_target(self, duration)
		return
	
	if pc.has_signal("deathblow_available"):
		pc.emit_signal("deathblow_available", self, duration)


func _on_base_posture_broken(_duration: float) -> void:
	# Virtual hook. Child enemies can override if they need extra behavior.
	_emit_posture_broken(_duration)


func _on_base_posture_meter_filled() -> void:
	# Virtual hook. Child enemies should override this.
	pass

func get_player_ref() -> Node2D:
	if is_instance_valid(player):
		return player
	
	player = get_tree().get_first_node_in_group("player") as Node2D
	return player
# =============================================================================
# UNIVERSAL HURTBOX / ATTACK METADATA HELPERS
# =============================================================================

func _resolve_hurt_source(attacker: Variant) -> Node:
	if attacker == null:
		return null
	if not is_instance_valid(attacker):
		return null
	
	if attacker is Area2D and attacker.has_meta("attacker"):
		var src = attacker.get_meta("attacker")
		if src is Node and is_instance_valid(src):
			return src
	
	var hb = get_hurtbox_node()
	if hb and hb.has_meta("last_attack_source"):
		var cached = hb.get_meta("last_attack_source")
		if cached is Node and is_instance_valid(cached):
			return cached
	
	return attacker as Node if attacker is Node else null


func _get_last_hurtbox_string_meta(key: String, fallback: String = "") -> String:
	var hb = get_hurtbox_node()
	if hb and hb.has_meta(key):
		return str(hb.get_meta(key))
	return fallback


func _get_last_hurtbox_float_meta(key: String, fallback: float = 0.0) -> float:
	var hb = get_hurtbox_node()
	if hb and hb.has_meta(key):
		return float(hb.get_meta(key))
	return fallback


func _get_last_hurtbox_int_meta(key: String, fallback: int = 0) -> int:
	var hb = get_hurtbox_node()
	if hb and hb.has_meta(key):
		return int(hb.get_meta(key))
	return fallback


func _get_last_hurtbox_node_meta(key: String) -> Node:
	var hb = get_hurtbox_node()
	if hb and hb.has_meta(key):
		var value = hb.get_meta(key)
		if value is Node and is_instance_valid(value):
			return value
	return null


func get_last_attack_id() -> String:
	return _get_last_hurtbox_string_meta("last_attack_id", "")


func get_last_damage_type() -> String:
	return _get_last_hurtbox_string_meta("last_damage_type", "normal")


func get_last_hitbox_shape() -> String:
	return _get_last_hurtbox_string_meta("last_hitbox_shape", "")


func get_last_posture_damage() -> float:
	return _get_last_hurtbox_float_meta("last_posture_damage", 0.0)


func get_last_knockback_force() -> float:
	return _get_last_hurtbox_float_meta("last_knockback_force", 0.0)


func get_last_hitstop() -> float:
	return _get_last_hurtbox_float_meta("last_hitstop", 0.0)


func get_last_combo_index() -> int:
	return _get_last_hurtbox_int_meta("last_combo_index", 0)


func get_last_attack_source() -> Node:
	return _get_last_hurtbox_node_meta("last_attack_source")


func get_last_attack_area() -> Node:
	return _get_last_hurtbox_node_meta("last_attack_area")


# =============================================================================
# UNIVERSAL INCOMING ATTACK RESPONSE TABLE
# =============================================================================

func _get_incoming_attack_response(damage: int, damage_type: String, attacker: Variant) -> Dictionary:
	var attack_id := get_last_attack_id()
	var posture_meta := get_last_posture_damage()
	if posture_meta <= 0.0:
		posture_meta = max(1.0, float(damage) * 0.5)
	
	var hitstop_meta := get_last_hitstop()
	if hitstop_meta <= 0.0:
		hitstop_meta = 0.06
	
	var knockback_meta := get_last_knockback_force()
	
	var response := {
		"hp_mult": 1.0,
		"posture_on_hit": max(1.0, posture_meta * 0.45),
		"posture_on_block": 3.0,
		"blockable": damage_type != "true" and damage_type != "unblockable",
		"heavy": false,
		"hitstop_hit": max(0.045, hitstop_meta),
		"hitstop_block": 0.04,
		"block_stagger": _get_default_block_stagger_time(),
		"block_knockback": 25.0,
		"hit_knockback": 0.0
	}
	
	match damage_type:
		"sword_light":
			response["posture_on_hit"] = max(5.0, posture_meta * 0.55)
			response["posture_on_block"] = 4.0
			response["hitstop_hit"] = 0.055
			response["hitstop_block"] = 0.040
			response["block_knockback"] = 24.0
		
		"sword_medium":
			response["posture_on_hit"] = max(9.0, posture_meta * 0.65)
			response["posture_on_block"] = 7.0
			response["hitstop_hit"] = 0.075
			response["hitstop_block"] = 0.050
			response["block_knockback"] = 34.0
		
		"sword_heavy":
			response["hp_mult"] = 1.0
			response["posture_on_hit"] = max(16.0, posture_meta * 0.80)
			response["posture_on_block"] = 14.0
			response["heavy"] = true
			response["hitstop_hit"] = 0.110
			response["hitstop_block"] = 0.075
			response["block_stagger"] = _get_heavy_block_stagger_time()
			response["block_knockback"] = 55.0
			response["hit_knockback"] = min(90.0, max(45.0, knockback_meta * 0.35))
		
		"sword_counter":
			response["hp_mult"] = 0.95
			response["posture_on_hit"] = max(24.0, posture_meta * 1.10)
			response["posture_on_block"] = 18.0
			response["blockable"] = false
			response["heavy"] = true
			response["hitstop_hit"] = 0.115
			response["hitstop_block"] = 0.075
			response["block_stagger"] = _get_heavy_block_stagger_time()
			response["hit_knockback"] = min(80.0, max(40.0, knockback_meta * 0.30))
		
		"sword_thrust":
			response["hp_mult"] = 1.0
			response["posture_on_hit"] = max(22.0, posture_meta * 0.90)
			response["posture_on_block"] = 11.0
			response["heavy"] = true
			response["hitstop_hit"] = 0.120
			response["hitstop_block"] = 0.065
			response["block_stagger"] = _get_heavy_block_stagger_time()
			response["block_knockback"] = 46.0
			response["hit_knockback"] = min(85.0, max(45.0, knockback_meta * 0.35))
		
		"sword_dash":
			response["hp_mult"] = 1.0
			response["posture_on_hit"] = max(7.0, posture_meta * 0.55)
			response["posture_on_block"] = 5.0
			response["hitstop_hit"] = 0.060
			response["hitstop_block"] = 0.045
			response["block_knockback"] = 30.0
			response["hit_knockback"] = min(50.0, max(25.0, knockback_meta * 0.25))
	
	if attack_id == "heavy_cleave":
		response["heavy"] = true
	elif attack_id == "counter_cut":
		response["blockable"] = false
		response["heavy"] = true
	elif attack_id == "hold_thrust":
		response["heavy"] = true
	
	if is_instance_valid(attacker) and attacker.has_meta("heavy_attack"):
		if bool(attacker.get_meta("heavy_attack")):
			response["heavy"] = true
	
	return response


func _get_default_block_stagger_time() -> float:
	return 0.08


func _get_heavy_block_stagger_time() -> float:
	return 0.12


# =============================================================================
# SHARED KNOCKBACK / HITSTOP HELPERS
# =============================================================================

func apply_knockback(force: Vector2) -> void:
	knockback += force


func tick_base_knockback(delta: float) -> void:
	if knockback.length() > 0.1:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery * 200.0 * delta)
	else:
		knockback = Vector2.ZERO


func hitstop_local(duration: float) -> void:
	_hitstop_until = max(_hitstop_until, Time.get_ticks_msec() * 0.001 + duration)


func is_in_hitstop() -> bool:
	return Time.get_ticks_msec() * 0.001 < _hitstop_until


func tick_base_hitstop() -> bool:
	var anim := get_animation_node()
	var now := Time.get_ticks_msec() * 0.001
	
	if now < _hitstop_until:
		velocity = Vector2.ZERO
		
		if anim:
			if not _hitstop_anim_paused:
				_hitstop_anim_paused = true
				_hitstop_saved_speed = anim.speed_scale
			anim.speed_scale = 0.0
		
		return true
	
	if anim and _hitstop_anim_paused:
		_hitstop_anim_paused = false
		anim.speed_scale = _hitstop_saved_speed
	
	return false


func _set_anim_speed_safe(new_speed: float) -> void:
	var anim := get_animation_node()
	if anim:
		anim.speed_scale = new_speed
	
	# Always update saved speed so hitstop restores correctly after attack transitions.
	_hitstop_saved_speed = new_speed


func _wait_for_hitstop() -> void:
	var now := Time.get_ticks_msec() * 0.001
	if now < _hitstop_until:
		var remaining = _hitstop_until - now
		await get_tree().create_timer(remaining + 0.01).timeout

func clear_hitstop_state() -> void:
	_hitstop_until = 0.0
	_hitstop_anim_paused = false
	_hitstop_saved_speed = 1.0
	
	var anim_node := get_animation_node()
	if anim_node:
		anim_node.speed_scale = 1.0
# =============================================================================
# SHARED VISUAL HELPERS
# =============================================================================

func _safe_queue_free(node: Variant) -> void:
	if node != null and is_instance_valid(node) and node is Node:
		(node as Node).queue_free()


func _flash_sprite(color: Color, duration: float) -> void:
	var sprite := get_sprite_node()
	if sprite == null:
		return
	
	# Do not wipe freeze tint during freeze.
	var frozen_until = float(get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
		return
	
	var original = sprite.modulate
	sprite.modulate = color
	
	var tw = get_tree().create_tween()
	tw.tween_interval(duration)
	tw.tween_property(sprite, "modulate", original, 0.01)


# =============================================================================
# SHARED POSTURE BAR UI
# =============================================================================

func _setup_posture_bar() -> void:
	if _posture_ui != null:
		return
	
	_posture_ui = Node2D.new()
	_posture_ui.name = "PostureBar"
	add_child(_posture_ui)
	_posture_ui.z_index = 100
	
	_posture_bg = ColorRect.new()
	_posture_bg.size = Vector2(50, 5)
	_posture_bg.color = Color(0.1, 0.1, 0.1, 0.7)
	_posture_bg.position = Vector2(-25, -35)
	_posture_ui.add_child(_posture_bg)
	
	_posture_fill = ColorRect.new()
	_posture_fill.size = Vector2(0, 5)
	_posture_fill.color = Color(0.9, 0.6, 0.1, 0.9)
	_posture_fill.position = Vector2(-25, -35)
	_posture_ui.add_child(_posture_fill)
	
	_posture_ui.visible = true


func _update_posture_bar(current: float, max_val: float) -> void:
	if _posture_ui == null:
		return
	
	_posture_ui.global_position = global_position
	
	if max_val <= 0.0 or current <= 0.0:
		_posture_ui.visible = false
		return
	
	_posture_ui.visible = true
	
	var pct = clamp(current / max_val, 0.0, 1.0)
	_posture_fill.size.x = 50.0 * pct
	
	var r = 0.9
	var g = 0.6 - (0.4 * pct)
	var b = 0.1
	_posture_fill.color = Color(r, g, b, 0.9)


func hide_posture_bar() -> void:
	if _posture_ui:
		_posture_ui.visible = false

# =============================================================================
# SHARED HEALTH HELPERS
# =============================================================================

func get_max_hp() -> int:
	if _max_hp <= 0:
		return hp
	return _max_hp


func get_hp_ratio() -> float:
	var max_hp = max(1, get_max_hp())
	return clamp(float(hp) / float(max_hp), 0.0, 1.0)


func is_dead() -> bool:
	return has_died or hp <= 0


func set_hp(value: int) -> void:
	hp = clamp(value, 0, get_max_hp())

func force_kill_hp() -> void:
	hp = 0
	
func apply_hp_damage(amount: int) -> int:
	var dmg = max(0, amount)
	var hp_before := hp
	if dmg <= 0:
		_last_applied_hp_damage = 0
		_pending_hp_damage_display = true
		return 0
	
	hp = max(0, hp - dmg)
	_last_applied_hp_damage = maxi(0, hp_before - hp)
	_pending_hp_damage_display = true
	# Preserve the legacy return contract for callers that use this helper as an
	# acknowledgement of the requested damage. Floating-number presentation uses
	# _last_applied_hp_damage instead so overkill can never inflate the visible value.
	return dmg

func heal_hp(amount: int) -> int:
	var heal = max(0, amount)
	var before = hp
	hp = min(get_max_hp(), hp + heal)
	return hp - before


func mark_dead() -> bool:
	if has_died:
		return false
	
	has_died = true
	return true


func sync_posture_bar_position() -> void:
	if _posture_ui:
		_posture_ui.global_position = global_position

# =============================================================================
# SHARED GENERAL UTILITIES
# =============================================================================

func _get_player() -> Node:
	return get_player_ref()


func _do_after(seconds: float, callback: Callable) -> void:
	if not callback.is_valid():
		return
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = maxf(0.001, seconds)
	add_child(timer)
	# Node-owned timers disappear with the enemy. Method Callables also disconnect
	# automatically with their target, avoiding orphaned SceneTreeTimer callbacks.
	timer.timeout.connect(callback)
	timer.timeout.connect(Callable(timer, "queue_free"))
	timer.start()

func add_posture_damage(amount: float) -> void:
	if amount <= 0.0:
		return
	
	if combat == null:
		return
	
	if combat.has_method("add_posture"):
		combat.add_posture(amount)
		return
	
	var cur = combat.get("posture")
	if cur == null:
		return
	
	var next := float(cur) + amount
	combat.set("posture", next)
	
	if combat.has_method("check_posture_break"):
		combat.check_posture_break()
		return
	
	var maxv = combat.get("max_posture")
	if maxv != null and next >= float(maxv):
		_on_base_posture_meter_filled()


func get_posture_value() -> float:
	if combat == null:
		return 0.0
	
	if combat.has_method("get_posture"):
		return float(combat.get_posture())
	
	var cur = combat.get("posture")
	if cur == null:
		return 0.0
	
	return float(cur)


func set_posture_value(value: float) -> void:
	if combat == null:
		return
	
	if combat.has_method("set_posture"):
		combat.set_posture(value)
		return
	
	if combat.get("posture") == null:
		return
	
	combat.set("posture", value)
	
	var maxv = combat.get("max_posture")
	if combat.has_signal("posture_changed") and maxv != null:
		combat.emit_signal("posture_changed", value, float(maxv))

func notify_combat_got_hit(event: Dictionary) -> void:
	if combat and combat.has_method("notify_got_hit"):
		combat.notify_got_hit(event)

func show_enemy_damage_number(amount: int, damage_type: String, y_offset: float = -20.0) -> void:
	var display_amount := amount
	if _pending_hp_damage_display:
		display_amount = mini(display_amount, _last_applied_hp_damage)
		_pending_hp_damage_display = false
		_last_applied_hp_damage = 0
	if display_amount <= 0:
		return
	
	if DamageNumberManager:
		DamageNumberManager.show_damage_number(
			display_amount,
			global_position + Vector2(randf_range(-10, 10), y_offset),
			damage_type,
			self
		)

func object_has_property(obj: Variant, property_name: String) -> bool:
	if obj == null or not is_instance_valid(obj):
		return false
	if not (obj is Object):
		return false
	return obj.get(property_name) != null


func object_get_property(obj: Variant, property_name: String, fallback: Variant = null) -> Variant:
	if obj == null or not is_instance_valid(obj):
		return fallback
	if not (obj is Object):
		return fallback
	var value = obj.get(property_name)
	if value == null:
		return fallback
	return value


func object_set_property_if_present(obj: Variant, property_name: String, value: Variant) -> void:
	if obj == null or not is_instance_valid(obj):
		return
	if not (obj is Object):
		return
	if obj.get(property_name) == null:
		return
	obj.set(property_name, value)

# =============================================================================
# SHARED ATTACK DIRECTOR HELPERS
# =============================================================================
func get_attack_director() -> Node:
	var ad := get_node_or_null("/root/AttackDir")
	if ad:
		return ad
	
	ad = get_node_or_null("/root/AttackDirector")
	if ad:
		return ad
	
	return null

func _request_role(role: String) -> bool:
	if _held_roles.has(role):
		return true
	
	var ad := get_attack_director()
	if ad == null:
		return false
	
	if not ad.has_method("request_role"):
		return false
	
	if bool(ad.request_role(self, role)):
		_held_roles[role] = true
		return true
	
	return false


func _release_role(role: String) -> void:
	if not _held_roles.has(role):
		return
	
	_held_roles.erase(role)
	
	var ad := get_attack_director()
	if ad and ad.has_method("release_role"):
		ad.release_role(self, role)


func _release_roles(roles: Array) -> void:
	for role in roles:
		_release_role(str(role))


func _release_all_roles() -> void:
	var roles := _held_roles.keys()
	for role in roles:
		_release_role(str(role))
	
	_held_roles.clear()


func _request_attack_token() -> bool:
	if has_attack_token:
		return true
	
	var ad := get_attack_director()
	if ad == null:
		return false
	
	if not ad.has_method("request_token"):
		return false
	
	if bool(ad.request_token(self)):
		has_attack_token = true
		_held_roles["melee_attack"] = true
		return true
	
	return false


func _release_attack_token() -> void:
	var ad := get_attack_director()
	
	if has_attack_token and ad and ad.has_method("release_token"):
		ad.release_token(self)
	
	has_attack_token = false
	_held_roles.erase("melee_attack")


func _release_all_attack_director_state() -> void:
	_release_all_roles()
	_release_attack_token()
	has_attack_token = false


func _attack_director_is_holding_role(role: String) -> bool:
	var ad := get_attack_director()
	if ad == null:
		return false
	
	if not ad.has_method("is_holding_role"):
		return false
	
	return bool(ad.is_holding_role(self, role))


func _attack_director_holder_count() -> int:
	var ad := get_attack_director()
	if ad == null:
		return 0
	
	if not ad.has_method("holder_count"):
		return 0
	
	return int(ad.holder_count())


func _attack_director_current_duelist() -> Node:
	var ad := get_attack_director()
	if ad == null:
		return null
	
	if not ad.has_method("get_current_duelist"):
		return null
	
	var duelist = ad.get_current_duelist()
	if duelist is Node and is_instance_valid(duelist):
		return duelist
	
	return null


func _connect_attack_director_signal(signal_name: String, callback: Callable) -> void:
	var ad := get_attack_director()
	if ad == null:
		return
	
	if not ad.has_signal(signal_name):
		return
	
	if not ad.is_connected(signal_name, callback):
		ad.connect(signal_name, callback)


func _disconnect_attack_director_signal(signal_name: String, callback: Callable) -> void:
	var ad := get_attack_director()
	if ad == null:
		return
	
	if not ad.has_signal(signal_name):
		return
	
	if ad.is_connected(signal_name, callback):
		ad.disconnect(signal_name, callback)


func _get_attack_director_float_property(property_name: String, fallback: float = 0.0) -> float:
	var ad := get_attack_director()
	if ad == null:
		return fallback
	
	var value = ad.get(property_name)
	if value == null:
		return fallback
	
	return float(value)
# =============================================================================
# SHARED DEATH / REWARD HELPERS
# =============================================================================

func notify_stance_effects_enemy_death() -> void:
	var se = get_node_or_null("/root/StanceEffects")
	if se and se.has_method("on_enemy_death"):
		se.on_enemy_death(self)


func spawn_death_vfx(death_scene: PackedScene) -> void:
	if death_scene == null:
		return
	
	var parent := get_parent()
	if parent == null or not is_instance_valid(parent):
		return
	
	var enemy_death := death_scene.instantiate() as Node2D
	if enemy_death == null:
		return
	
	if sprite:
		enemy_death.scale = sprite.scale
	
	enemy_death.global_position = global_position
	parent.call_deferred("add_child", enemy_death)


func _resolve_live_loot_parent(preferred: Variant = null) -> Node:
	# Cached chamber nodes can become freed when RunScene swaps rooms. Resolve a live
	# owner at the moment a reward is spawned instead of trusting an @onready cache.
	if preferred != null and is_instance_valid(preferred) and preferred is Node:
		var preferred_node := preferred as Node
		if preferred_node.is_inside_tree():
			return preferred_node

	var ancestor: Node = get_parent()
	while ancestor != null:
		if not is_instance_valid(ancestor):
			break
		var direct_loot := ancestor.get_node_or_null("Loot")
		if direct_loot != null and is_instance_valid(direct_loot) and direct_loot.is_inside_tree():
			return direct_loot
		ancestor = ancestor.get_parent()

	for candidate in get_tree().get_nodes_in_group("loot"):
		if candidate is Node and is_instance_valid(candidate) and candidate.is_inside_tree():
			return candidate

	var fallback := get_parent()
	if fallback != null and is_instance_valid(fallback) and fallback.is_inside_tree():
		return fallback
	return null


func spawn_experience_gem(exp_scene: PackedScene, loot_parent: Variant = null) -> void:
	if exp_scene == null:
		return
	
	var new_gem := exp_scene.instantiate() as Node2D
	if new_gem == null:
		return
	
	new_gem.global_position = global_position
	new_gem.set("experience", experience)
	
	var live_parent := _resolve_live_loot_parent(loot_parent)
	if live_parent != null:
		live_parent.call_deferred("add_child", new_gem)
	else:
		# Never leave a detached reward node alive if a room is tearing down.
		new_gem.queue_free()


func award_area_gold_drop() -> void:
	var rd = get_node_or_null("/root/RunData")
	if rd == null:
		return
	
	var area_id = rd.get("current_area_id")
	var gold_drop := 0
	
	match int(area_id):
		1:
			gold_drop = randi_range(3, 6)
		2:
			gold_drop = randi_range(5, 8)
		3:
			gold_drop = randi_range(7, 12)
		_:
			gold_drop = randi_range(3, 6)
	
	if rd.has_method("add_gold"):
		rd.add_gold(gold_drop)


func base_death_cleanup() -> void:
	hide_posture_bar()
	queue_free()

# =============================================================================
# GENERIC DAMAGE RECEIVER
# =============================================================================
# Default damage receiver for enemies that do not need custom blocking or special
# hurt routing. Humanoid enemies like CorruptedSwordsman can still override this.

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died:
		return
	
	if damage <= 0 and damage_type != "knockback":
		return
	
	var source := _resolve_hurt_source(attacker)
	
	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return
	
	var response := _get_incoming_attack_response(damage, damage_type, attacker)
	var hp_damage := int(round(float(damage) * float(response.get("hp_mult", 1.0))))
	
	add_posture_damage(float(response.get("posture_on_hit", max(1.0, float(damage) * 0.5))))
	
	var hit_kb := float(response.get("hit_knockback", 0.0))
	if hit_kb > 0.0:
		var kb_source: Node = source if source else attacker
		if kb_source is Node2D:
			var kb_dir = (global_position - kb_source.global_position).normalized()
			apply_knockback(kb_dir * hit_kb)
	
	hitstop_local(float(response.get("hitstop_hit", 0.06)))
	apply_hp_damage(hp_damage)
	
	if hp_damage > 0:
		var is_crit := false
		if source and source.has_method("is_critical_strike") and source.is_critical_strike():
			is_crit = true
		
		var display_type := "critical" if is_crit else damage_type
		show_enemy_damage_number(hp_damage, display_type, -20.0)
	
	notify_combat_got_hit({
		"damage": damage,
		"blocked": false,
		"damage_type": damage_type
	})
	
	# Current prosthetic/stance-era systems.
	if hp_damage > 0 and is_instance_valid(player):
		if player.has_meta("smoke_slash_ready") and player.get_meta("smoke_slash_ready"):
			var bonus_hp := int(hp_damage * 0.5)
			var bonus_posture := 8.0
			
			apply_hp_damage(bonus_hp)
			add_posture_damage(bonus_posture)
			show_enemy_damage_number(bonus_hp, "prosthetic", -25.0)
			player.set_meta("smoke_slash_ready", false)
		
		ProstheticEffects.check_lifesteal(player, hp_damage)
	
	_on_base_damaged(hp_damage, damage_type, source, response)
	
	if hp <= 0:
		_on_base_killed_by_damage(source, damage_type)


func _on_base_damaged(_hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	pass


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()
	
# =============================================================================
# VIRTUAL / SHARED API
# =============================================================================
func get_enemy_tags() -> Array:
	return enemy_tags

func is_deathblow_ready() -> bool:
	return false


func receive_deathblow(_attacker: Node) -> void:
	pass

func death() -> void:
	if not mark_dead():
		return
	
	emit_signal("enemy_died", self)
	base_death_cleanup()

func _emit_received_hit(event: Dictionary) -> void:
	emit_signal("enemy_received_hit", self, event)


func _emit_posture_broken(duration: float) -> void:
	emit_signal("enemy_posture_broken", self, duration)

func safe_play_anim(anim_name: String, restart: bool = false) -> bool:
	var a := get_animation_node()
	if a == null:
		return false
	
	if not a.has_animation(anim_name):
		return false
	
	if restart:
		a.stop()
	
	a.play(anim_name)
	return true