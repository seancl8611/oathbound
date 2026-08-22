extends Node2D
class_name RestHealer

signal rest_used

const ACTION_INTERACT := "interact"
@export var heal_amount: int = 50

@onready var area: Area2D = $Area2D
var prompt: Label
var _inside: bool = false
var _used: bool = false


func _ready() -> void:
	prompt = get_node_or_null("Prompt") as Label
	if prompt == null:
		prompt = get_node_or_null("Area2D/Prompt") as Label
	if prompt:
		prompt.visible = false
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)


func _physics_process(_delta: float) -> void:
	if _inside and not _used and Input.is_action_just_pressed(ACTION_INTERACT):
		_do_rest()


func _effective_heal_amount() -> int:
	if typeof(MetaProgressionManager) == TYPE_OBJECT and MetaProgressionManager.has_method("get_rest_heal_amount"):
		return int(MetaProgressionManager.call("get_rest_heal_amount", heal_amount))
	return heal_amount


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_inside = true
		if not _used and prompt:
			prompt.visible = true
			prompt.text = "Rest (+%d HP)" % _effective_heal_amount()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_inside = false
		if prompt:
			prompt.visible = false


func _do_rest() -> void:
	_used = true
	var amount := _effective_heal_amount()
	_heal_player(amount)
	if prompt:
		prompt.visible = true
		prompt.text = "+%d HP" % amount
	rest_used.emit()
	var timer := get_tree().create_timer(1.2)
	timer.timeout.connect(func() -> void:
		if prompt:
			prompt.visible = false
	)


func _heal_player(amount: int) -> void:
	var ps := get_node_or_null("/root/PlayerState")
	if ps and ps.has_method("heal"):
		ps.heal(amount)
		return
	for p in get_tree().get_nodes_in_group("player"):
		if p.has_method("heal"):
			p.heal(amount)
		elif p.has_meta("hp"):
			var hp := int(p.get_meta("hp"))
			var max_hp := int(p.get_meta("max_hp")) if p.has_meta("max_hp") else hp
			p.set_meta("hp", clamp(hp + amount, 0, max_hp))
