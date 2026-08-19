extends Control

@export var icon_scene := preload("res://Player/GUI/ChargeIcon.tscn")
@onready var flow = $Flow

var max_charges := 5
var current_charges := 5

func _ready():
	print("[DEBUG] ChargeBar ready - max_charges:", max_charges)

func set_charges(current: int, max: int):
	current_charges = current
	max_charges = max
	print("[DEBUG] set_charges() called - current:", current_charges, "max:", max_charges)
	_update_icons()

func _update_icons():
	print("[DEBUG] _update_icons() called")

	for child in flow.get_children():
		child.queue_free()

	for i in range(max_charges):
		var icon = icon_scene.instantiate()
		if icon == null:
			print("[ERROR] icon_scene failed to instantiate")
			continue

		icon.modulate.a = 1.0 if i < current_charges else 0.25

		# ✅ Force size (if TextureRect or Control-based)
		if icon is Control:
			icon.custom_minimum_size = Vector2(16, 16)

		flow.add_child(icon)

	print("[DEBUG] Spawned", max_charges, "icons. Current full:", current_charges)
