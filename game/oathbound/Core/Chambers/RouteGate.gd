# MistGate.gd
extends Node2D
class_name MistGate

signal gate_used(gate_type: String)

@export var gate_type: String = "Combat"
@export var locked: bool = true
@export var entry_grace_seconds: float = 0.0

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var area: Area2D = get_node_or_null("Area2D")
@onready var shape: CollisionShape2D = get_node_or_null("Area2D/CollisionShape2D")

var _used: bool = false
var _entry_grace_until_msec: int = 0

func _ready() -> void:
	add_to_group("mist_gates")
	_entry_grace_until_msec = Time.get_ticks_msec() + int(round(maxf(0.0, entry_grace_seconds) * 1000.0))
	if area and not area.body_entered.is_connected(Callable(self, "_on_Area2D_body_entered")):
		area.body_entered.connect(_on_Area2D_body_entered)
	_apply_indicator()
	_apply_collision()

func set_indicator(next_type: String) -> void:
	gate_type = next_type
	_apply_indicator()

func lock() -> void:
	locked = true
	_used = false
	call_deferred("_apply_collision")

func unlock() -> void:
	locked = false
	call_deferred("_apply_collision")

func _apply_collision() -> void:
	# Toggle the sensing shape
	if shape:
		shape.set_deferred("disabled", locked)
	# Ensure the Area2D actually monitors when unlocked
	if area:
		area.set_deferred("monitorable", not locked)
		area.set_deferred("monitoring", not locked)
	# Visual alpha
	if sprite:
		var m := sprite.modulate
		m.a = 0.9 if locked else 0.5
		sprite.set_deferred("modulate", m)

func _apply_indicator() -> void:
	var token := str(gate_type)
	var base := token
	if base.find(":") != -1:
		base = base.split(":", false)[0]

	var t := base
	if t.ends_with("Room"):
		t = t.substr(0, t.length() - 4)

	# Normalize for match
	t = t.capitalize()

	var color := Color.WHITE
	match t:
		"Combat":    color = Color(0.9,0.9,1.0)
		"Miniboss":  color = Color(1.0,0.4,0.4)
		"Shrine":    color = Color(0.6,0.8,1.0)
		"Shop":      color = Color(1.0,0.95,0.6)
		"Treasure":  color = Color(1.0,0.85,0.4)
		"Npc":       color = Color(0.7,1.0,0.8)
		"Event":     color = Color(0.8,0.8,0.8)
		"Rest":      color = Color(0.7,1.0,0.8)
		"Boss":      color = Color(1.0,0.3,0.3)
		_:           color = Color(1,1,1)

	if $Sprite2D:
		$Sprite2D.modulate = color

func _on_Area2D_body_entered(body: Node) -> void:
	if locked or _used:
		return
	# During chamber transitions the persistent Player is briefly re-parented at its
	# previous room coordinates before GameFlow places it at the new PlayerSpawn.
	# Merchant exits are intentionally open immediately, so they opt into a tiny
	# scene-authored grace window to ignore that stale-position overlap.
	if Time.get_ticks_msec() < _entry_grace_until_msec:
		return
	print("[MistGate] body_entered=", body.name, " locked=", locked, " is_player=", _is_player_body(body))
	if _is_player_body(body):
		# body_entered runs while the 2D physics server is flushing contact callbacks.
		# A gate listener is allowed to replace a chamber or change the whole scene, but
		# removing CollisionObjects from this callback is illegal in Godot. Mark the gate
		# consumed now, then emit on the deferred queue so every gate-driven transition
		# (ordinary room, regional boss, Heart handoff, future gates) leaves physics first.
		_used = true
		call_deferred("_emit_gate_used", gate_type)

func _emit_gate_used(type_at_contact: String) -> void:
	if not is_inside_tree():
		return
	emit_signal("gate_used", type_at_contact)

func _is_player_body(n: Node) -> bool:
	var cur := n
	var steps := 0
	while cur != null and steps < 6:
		if cur.is_in_group("player"):
			return true
		cur = cur.get_parent()
		steps += 1
	return false
