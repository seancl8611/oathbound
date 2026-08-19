extends Area2D

# 0 = Player, 1 = Enemy
@export_enum("Player", "Enemy") var HurtBoxType: int = 0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var disableTimer: Timer = $DisableTimer
@export var hurtbox_owner: StringName = &"Enemy"

# --- Same-frame de-dupe for hurt emissions ---
var _emit_frame := -1
var _emit_guard := {}
var _dot_sources: Dictionary = {}

# --- Cached faction (determined once in _ready) ---
var _is_player_hurtbox: bool = false
var _is_enemy_hurtbox: bool = false

# Compatibility signal. Rich AttackEvent fields are cached as metadata before emit.
signal hurt(damage: int, damage_type: String, attacker: Node)

func _ready() -> void:
	_determine_faction()

	if _is_player_hurtbox:
		if not is_in_group("player_hurtbox"):
			add_to_group("player_hurtbox")
		collision_layer = 4
		if (collision_mask & 2) == 0:
			collision_mask |= 2
	elif _is_enemy_hurtbox:
		if not is_in_group("enemy_hurtbox"):
			add_to_group("enemy_hurtbox")
		if (collision_mask & 2) == 0:
			collision_mask |= 2

	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))
	if not is_connected("area_exited", Callable(self, "_on_area_exited")):
		connect("area_exited", Callable(self, "_on_area_exited"))
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

	var owner_node := get_parent()
	if owner_node and owner_node.has_method("_on_hurt_box_hurt"):
		if not is_connected("hurt", Callable(owner_node, "_on_hurt_box_hurt")):
			connect("hurt", Callable(owner_node, "_on_hurt_box_hurt"))


func _determine_faction() -> void:
	var owner_node := get_parent()

	if owner_node:
		if owner_node.is_in_group("player"):
			_is_player_hurtbox = true
			_is_enemy_hurtbox = false
			return
		elif owner_node.is_in_group("enemy") or owner_node.is_in_group("miniboss"):
			_is_player_hurtbox = false
			_is_enemy_hurtbox = true
			return

	if HurtBoxType == 0:
		_is_player_hurtbox = true
		_is_enemy_hurtbox = false
	else:
		_is_player_hurtbox = false
		_is_enemy_hurtbox = true


func tempdisable() -> void:
	if collision:
		collision.call_deferred("set", "disabled", true)
	if disableTimer:
		disableTimer.start()

func _on_disable_timer_timeout() -> void:
	if collision:
		collision.call_deferred("set", "disabled", false)

func _on_body_entered(body: Node) -> void:
	if body == null:
		return
	if body.is_in_group("player") or body.is_in_group("enemy"):
		return

	if body.is_in_group("hazard") and body.has_meta("contact_damage"):
		var dmg := int(body.get_meta("contact_damage"))
		if dmg > 0:
			var attacker: Node = body
			if body.has_meta("attacker") and (body.get_meta("attacker") is Node):
				attacker = body.get_meta("attacker")
			if _is_friendly_fire(attacker):
				return
			_emit_hurt_once_per_frame(dmg, "normal", attacker)


func _is_friendly_fire(attacker: Node) -> bool:
	if attacker == null:
		return false

	var owner_node = get_parent()
	if attacker == owner_node:
		return true

	var source_entity = attacker
	if attacker is Area2D and attacker.has_meta("attacker"):
		var src = attacker.get_meta("attacker")
		if src is Node and is_instance_valid(src):
			source_entity = src

	if _is_player_hurtbox:
		if source_entity.is_in_group("player"):
			return true
	elif _is_enemy_hurtbox:
		if source_entity.is_in_group("enemy") or source_entity.is_in_group("miniboss"):
			return true

	return false

func _read_health_damage(area: Area2D) -> int:
	if area.has_meta("health_damage"):
		return int(area.get_meta("health_damage"))
	if area.has_meta("damage"):
		return int(area.get_meta("damage"))
	return 0

func _is_canonical_attack_event(area: Area2D) -> bool:
	return area.has_meta("health_damage") and area.has_meta("posture_damage") and area.has_meta("block_posture_damage")

func _cache_attack_event(area: Area2D, resolved_attacker: Node) -> void:
	if area == null:
		return

	var health_damage := _read_health_damage(area)
	var posture_damage := float(area.get_meta("posture_damage")) if area.has_meta("posture_damage") else 0.0
	var block_posture_damage := float(area.get_meta("block_posture_damage")) if area.has_meta("block_posture_damage") else posture_damage
	var stagger_level := int(area.get_meta("stagger_level")) if area.has_meta("stagger_level") else 0
	var proc_coefficient := float(area.get_meta("proc_coefficient")) if area.has_meta("proc_coefficient") else 1.0

	set_meta("last_attack_area", area)
	set_meta("last_attack_source", resolved_attacker)

	# Canonical Oathbound AttackEvent cache.
	set_meta("last_health_damage", health_damage)
	set_meta("last_posture_damage", posture_damage)
	set_meta("last_block_posture_damage", block_posture_damage)
	set_meta("last_stagger_level", stagger_level)
	set_meta("last_proc_coefficient", proc_coefficient)

	# Compatibility cache used by imported enemy scripts.
	set_meta("last_damage", health_damage)
	set_meta("last_damage_type", str(area.get_meta("damage_type")) if area.has_meta("damage_type") else "normal")
	set_meta("last_attack_id", str(area.get_meta("attack_id")) if area.has_meta("attack_id") else "")
	set_meta("last_hitbox_shape", str(area.get_meta("hitbox_shape")) if area.has_meta("hitbox_shape") else "")
	set_meta("last_combo_index", int(area.get_meta("combo_index")) if area.has_meta("combo_index") else 0)
	set_meta("last_knockback_force", float(area.get_meta("knockback_force")) if area.has_meta("knockback_force") else 0.0)
	set_meta("last_hitstop", float(area.get_meta("hitstop")) if area.has_meta("hitstop") else 0.0)

func get_last_attack_event() -> Dictionary:
	return {
		"health_damage": int(get_meta("last_health_damage", 0)),
		"posture_damage": float(get_meta("last_posture_damage", 0.0)),
		"block_posture_damage": float(get_meta("last_block_posture_damage", 0.0)),
		"stagger_level": int(get_meta("last_stagger_level", 0)),
		"proc_coefficient": float(get_meta("last_proc_coefficient", 1.0)),
		"attack_id": str(get_meta("last_attack_id", "")),
		"source": get_meta("last_attack_source", null),
	}

func _get_owner_combat() -> Node:
	var owner_node := get_parent()
	if owner_node == null:
		return null
	return owner_node.get_node_or_null("Combat")

func _begin_attack_event_transaction() -> Node:
	if not _is_enemy_hurtbox:
		return null
	var combat_node := _get_owner_combat()
	if combat_node and combat_node.has_method("begin_attack_event"):
		combat_node.call("begin_attack_event", get_last_attack_event())
		return combat_node
	return null

func _end_attack_event_transaction(combat_node: Node) -> void:
	if combat_node and is_instance_valid(combat_node) and combat_node.has_method("end_attack_event"):
		combat_node.call("end_attack_event")

func _emit_hurt_once_per_frame(dmg: int, dmg_type: String, attacker: Node) -> void:
	var pf := Engine.get_physics_frames()
	if pf != _emit_frame:
		_emit_frame = pf
		_emit_guard.clear()

	var aid := attacker.get_instance_id() if attacker != null else 0
	var key := "%s|%d|%s" % [str(aid), dmg, dmg_type]
	if _emit_guard.has(key):
		return
	_emit_guard[key] = true
	emit_signal("hurt", dmg, dmg_type, attacker)

func _show_damage_number_for_enemy(damage: int, damage_type: String, attacker: Node) -> void:
	if not _is_enemy_hurtbox:
		return
	if damage <= 0:
		return
	if not has_node("/root/World/DamageNumberManager"):
		return

	var mgr = get_node("/root/World/DamageNumberManager")
	if mgr and mgr.has_method("show_damage_number"):
		mgr.show_damage_number(damage, global_position, damage_type, attacker)

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		return
	if not area.is_in_group("attack"):
		return
	if (not area.monitoring) or (not area.monitorable):
		return
	if area.has_meta("consumed") and area.get_meta("consumed"):
		return

	var attacker: Node = area
	if not area.has_meta("prosthetic_source"):
		if area.has_meta("attacker") and (area.get_meta("attacker") is Node):
			attacker = area.get_meta("attacker")

	if _is_friendly_fire(attacker):
		return

	_cache_attack_event(area, attacker)

	if area.has_meta("dot_tick") and area.has_meta("damage_per_tick"):
		var tick = float(area.get_meta("dot_tick"))
		var dmg = float(area.get_meta("damage_per_tick"))
		_dot_sources[area] = {"acc": 0.0, "tick": max(0.01, tick), "dmg": dmg, "dmg_acc": 0.0}

		if area.has_meta("slow_pct"):
			emit_signal("hurt", 0, "puddle", area)
		return

	var dmg_once = _read_health_damage(area)
	var dmg_type = str(area.get_meta("damage_type")) if area.has_meta("damage_type") else "normal"
	var canonical_event := _is_canonical_attack_event(area)
	var receiver: Node = get_parent()
	var telemetry_before: Dictionary = {}
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		telemetry_before = CombatTelemetry.snapshot_actor(receiver)

	# Legacy EnemyBase contains an old damage-type response table that scales HP and
	# Posture. Canonical events already authored those values, so use a neutral legacy
	# type for the compatibility callback while retaining the real type in cached meta.
	var receiver_damage_type: String = "oathbound_attack" if canonical_event else str(dmg_type)
	var event_combat: Node = _begin_attack_event_transaction() if canonical_event else null
	_emit_hurt_once_per_frame(dmg_once, receiver_damage_type, attacker)
	_end_attack_event_transaction(event_combat)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_contact(receiver, area, attacker, telemetry_before)

	# Legacy imported stance layer remains connected until the Technique-system
	# reconciliation replaces it. Keeping this here avoids breaking the old build
	# while core combat is migrated in isolation.
	if _is_enemy_hurtbox and not area.has_meta("prosthetic_source"):
		if is_instance_valid(attacker) and attacker.is_in_group("player"):
			var enemy_node = get_parent()
			if is_instance_valid(enemy_node):
				var se = get_node_or_null("/root/StanceEffects")
				if se:
					se.on_player_hit(enemy_node, attacker)

func _on_area_exited(area: Area2D) -> void:
	if _dot_sources.has(area):
		_dot_sources.erase(area)

func _physics_process(delta: float) -> void:
	if _dot_sources.is_empty():
		return

	for area in _dot_sources.keys().duplicate():
		if not is_instance_valid(area):
			_dot_sources.erase(area)
			continue

		var dot_attacker: Node = area
		if area.has_meta("attacker") and (area.get_meta("attacker") is Node):
			dot_attacker = area.get_meta("attacker")

		if _is_friendly_fire(dot_attacker):
			_dot_sources.erase(area)
			continue

		var rec = _dot_sources[area]
		rec["acc"] = rec["acc"] + delta

		while rec["acc"] >= rec["tick"]:
			rec["acc"] = rec["acc"] - rec["tick"]
			rec["dmg_acc"] = rec["dmg_acc"] + rec["dmg"]
			var deal := int(floor(rec["dmg_acc"]))

			if deal >= 1:
				rec["dmg_acc"] = rec["dmg_acc"] - float(deal)
				var atype := str(area.get_meta("attack_type")) if area.has_meta("attack_type") else "puddle"
				emit_signal("hurt", deal, atype, area)
			else:
				emit_signal("hurt", 0, "puddle", area)

		_dot_sources[area] = rec
