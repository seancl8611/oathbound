extends Node3D

## Standalone Hushiro 3D composition lab retained for fast art/camera experiments.
##
## This scene does NOT own production combat. The live Hushiro CombatChamber now uses
## HushiroPlanar3DPresentationBridge, which mirrors the authoritative CharacterBody2D
## simulation into Camera3D presentation while preserving combat timing/range/pressure
## semantics. Keep this isolated scene only for experiments that do not require live
## Combat V2 behavior; production presentation changes should ultimately land in the
## live bridge/environment/actor stack and its validation.

@export var move_speed: float = 4.6
@export var camera_follow_speed: float = 8.0
@export var dash_preview_multiplier: float = 2.15

const CAMERA_OFFSET := Vector3(0.0, 12.5, 10.5)
const ROOM_HALF_X := 9.0
const ROOM_HALF_Z := 5.6

@onready var akio: Node3D = $Actors/AkioPrototype
@onready var camera: Camera3D = $Camera3D

var _last_move_dir := Vector3(0.0, 0.0, -1.0)


func _ready() -> void:
	_update_camera(true)


func _process(delta: float) -> void:
	_update_akio_preview(delta)
	_update_camera(false, delta)


func _update_akio_preview(delta: float) -> void:
	if akio == null:
		return

	var input := Input.get_vector("left", "right", "up", "down")
	if input.length_squared() <= 0.001:
		return

	var direction := Vector3(input.x, 0.0, input.y).normalized()
	_last_move_dir = direction
	var speed := move_speed
	if Input.is_action_pressed("dash"):
		speed *= dash_preview_multiplier

	var next := akio.position + direction * speed * delta
	next.x = clampf(next.x, -ROOM_HALF_X + 0.7, ROOM_HALF_X - 0.7)
	next.z = clampf(next.z, -ROOM_HALF_Z + 0.7, ROOM_HALF_Z - 0.7)
	akio.position = next

	# The blockout mesh faces local -Z. Keep the silhouette aligned to travel so the
	# high-angle camera can be judged with the same directional reads combat will need.
	akio.rotation.y = atan2(-direction.x, -direction.z)


func _update_camera(snap: bool, delta: float = 0.0) -> void:
	if akio == null or camera == null:
		return

	var desired := akio.position + CAMERA_OFFSET
	if snap:
		camera.position = desired
	else:
		var weight := 1.0 - exp(-camera_follow_speed * maxf(delta, 0.0))
		camera.position = camera.position.lerp(desired, weight)
	camera.look_at(akio.position + Vector3(0.0, 0.65, 0.0), Vector3.UP)
