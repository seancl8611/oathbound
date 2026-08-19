extends Area2D

# 0 = Player, 1 = Enemy
@export_enum("Player", "Enemy") var HurtBoxType: int = 0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var disableTimer: Timer = $DisableTimer
@export var hurtbox_owner: StringName = &"Enemy" # "Player" or "Enemy"

# --- Same-frame de-dupe for hurt emissions ---
var _emit_frame := -1
var _emit_guard := {}  # key -> true, reset each physics frame
var _dot_sources: Dictionary = {}   # area -> {acc: float, tick: float, dmg: float, dmg_acc: float}

# --- Cached faction (determined once in _ready) ---
var _is_player_hurtbox: bool = false
var _is_enemy_hurtbox: bool = false

# Canonical hurt event for receivers: (damage, damage_type, attacker)
signal hurt(damage: int, damage_type: String, attacker: Node)

func _ready() -> void:
	# === Determine faction based on HurtBoxType AND parent's groups ===
	_determine_faction()
	
	# Ensure expected group and collision setup based on determined faction
	if _is_player_hurtbox:
		if not is_in_group("player_hurtbox"):
			add_to_group("player_hurtbox")
		collision_layer = 4
		if (collision_mask & 2) == 0:
			collision_mask |= 2
	elif _is_enemy_hurtbox:
		if not is_in_group("enemy_hurtbox"):
			add_to_group("enemy_hurtbox")
		# NOTE: Do NOT add to "enemy" group - that breaks player dash!
		if (collision_mask & 2) == 0:
			collision_mask |= 2

	# Connect once
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))
	if not is_connected("area_exited", Callable(self, "_on_area_exited")):
		connect("area_exited", Callable(self, "_on_area_exited"))
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	
	# === AUTO-CONNECT hurt signal to owner's _on_hurt_box_hurt ===
	var owner_node := get_parent()
	if owner_node and owner_node.has_method("_on_hurt_box_hurt"):
		if not is_connected("hurt", Callable(owner_node, "_on_hurt_box_hurt")):
			connect("hurt", Callable(owner_node, "_on_hurt_box_hurt"))


func _determine_faction() -> void:
	# First, check if the parent's group membership gives us a clear answer
	var owner_node := get_parent()
	
	if owner_node:
		# Check parent's groups - this takes priority for accuracy
		if owner_node.is_in_group("player"):
			_is_player_hurtbox = true
			_is_enemy_hurtbox = false
			return
		elif owner_node.is_in_group("enemy") or owner_node.is_in_group("miniboss"):
			_is_player_hurtbox = false
			_is_enemy_hurtbox = true
			return
	
	# Fallback to the exported HurtBoxType
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

	# Ignore player/enemy bodies (their real attacks arrive via Areas in "attack")
	if body.is_in_group("player") or body.is_in_group("enemy"):
		return

	# Allow hazards or other bodies to deal contact damage via meta
	if body.is_in_group("hazard") and body.has_meta("contact_damage"):
		var dmg := int(body.get_meta("contact_damage"))
		if dmg > 0:
			var attacker: Node = body
			if body.has_meta("attacker") and (body.get_meta("attacker") is Node):
				attacker = body.get_meta("attacker")
			
			# Check for friendly fire on body damage too
			if _is_friendly_fire(attacker):
				return
			
			_emit_hurt_once_per_frame(dmg, "normal", attacker)


# === Helper to detect friendly fire / self-damage ===
func _is_friendly_fire(attacker: Node) -> bool:
	if attacker == null:
		return false
	
	# Get the owner of this hurtbox
	var owner_node = get_parent()
	
	# Direct self-damage check
	if attacker == owner_node:
		return true
	
	# === Resolve source for prosthetic / player-owned areas ===
	var source_entity = attacker
	if attacker is Area2D and attacker.has_meta("attacker"):
		var src = attacker.get_meta("attacker")
		if src is Node and is_instance_valid(src):
			source_entity = src
	
	# === FACTION-BASED FRIENDLY FIRE CHECK ===
	if _is_player_hurtbox:
		if source_entity.is_in_group("player"):
			return true
	elif _is_enemy_hurtbox:
		if source_entity.is_in_group("enemy") or source_entity.is_in_group("miniboss"):
			return true
	
	return false

func _cache_attack_event(area: Area2D, resolved_attacker: Node) -> void:
	if area == null:
		return
	
	set_meta("last_attack_area", area)
	set_meta("last_attack_source", resolved_attacker)
	set_meta("last_damage", int(area.get_meta("damage")) if area.has_meta("damage") else 0)
	set_meta("last_damage_type", str(area.get_meta("damage_type")) if area.has_meta("damage_type") else "normal")
	set_meta("last_attack_id", str(area.get_meta("attack_id")) if area.has_meta("attack_id") else "")
	set_meta("last_hitbox_shape", str(area.get_meta("hitbox_shape")) if area.has_meta("hitbox_shape") else "")
	set_meta("last_combo_index", int(area.get_meta("combo_index")) if area.has_meta("combo_index") else 0)
	set_meta("last_posture_damage", float(area.get_meta("posture_damage")) if area.has_meta("posture_damage") else 0.0)
	set_meta("last_knockback_force", float(area.get_meta("knockback_force")) if area.has_meta("knockback_force") else 0.0)
	set_meta("last_hitstop", float(area.get_meta("hitstop")) if area.has_meta("hitstop") else 0.0)
	
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

	# Unified emit: (damage, damage_type, attacker)
	emit_signal("hurt", dmg, dmg_type, attacker)

func _show_damage_number_for_enemy(damage: int, damage_type: String, attacker: Node) -> void:
	# Only show damage numbers for enemy HurtBoxes
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

	# === Determine the TRUE attacker/source ===
	var attacker: Node = area
	
	# For prosthetic areas, keep the Area2D itself as attacker so receivers
	# can read prosthetic metas. For normal attacks, resolve to owning entity.
	if not area.has_meta("prosthetic_source"):
		if area.has_meta("attacker") and (area.get_meta("attacker") is Node):
			attacker = area.get_meta("attacker")

	# === Prevent friendly fire / self-damage BEFORE processing ===
	if _is_friendly_fire(attacker):
		return

	# Cache rich attack metadata on the HurtBox.
	# This is the universal bridge for all enemies, including enemies that do not extend enemy.gd.
	_cache_attack_event(area, attacker)

	# DoT puddle: start tracking
	if area.has_meta("dot_tick") and area.has_meta("damage_per_tick"):
		var tick = float(area.get_meta("dot_tick"))
		var dmg  = float(area.get_meta("damage_per_tick"))
		_dot_sources[area] = {"acc": 0.0, "tick": max(0.01, tick), "dmg": dmg, "dmg_acc": 0.0}
		
		# Apply slow immediately if present; real damage happens in _physics_process.
		if area.has_meta("slow_pct"):
			emit_signal("hurt", 0, "puddle", area)
		return

	# Non-DoT: emit once immediately.
	var dmg_once = int(area.get_meta("damage")) if area.has_meta("damage") else 0
	var dmg_type = str(area.get_meta("damage_type")) if area.has_meta("damage_type") else "normal"

	_emit_hurt_once_per_frame(dmg_once, dmg_type, attacker)

	# === STANCE EFFECTS: player attack hit an enemy ===
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

		# Re-check friendly fire for DoT sources
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

			# accumulate fractional damage to emit whole integers
			rec["dmg_acc"] = rec["dmg_acc"] + rec["dmg"]
			var deal := int(floor(rec["dmg_acc"]))

			if deal >= 1:
				rec["dmg_acc"] = rec["dmg_acc"] - float(deal)
				var atype := str(area.get_meta("attack_type")) if area.has_meta("attack_type") else "puddle"
				emit_signal("hurt", deal, atype, area)
			else:
				# even with 0 dmg, refresh slow/posture meta on the player
				emit_signal("hurt", 0, "puddle", area)

		_dot_sources[area] = rec
