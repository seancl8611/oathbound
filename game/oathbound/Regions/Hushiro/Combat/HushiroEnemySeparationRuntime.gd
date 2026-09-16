extends Node

## Hushiro-only standard-enemy overlap guard added from the first live 3D acceptance pass.
##
## Telemetry from that pass showed player/enemy clearance was healthy while standard
## enemies repeatedly compressed into one another, producing a visually unreadable actor
## pile. This is deliberately a physical-overlap correction, not a new tactical spacing
## system: it only acts inside a small minimum body clearance and does not change Pressure
## Director admission, attack ranges, cooldowns, target selection or authored destinations.

const STANDARD_HUSHIRO_ROLES: Array[String] = [
	"swordsman",
	"hound",
	"hollow",
	"archer",
	"bilemass",
	"warden",
]
const MIN_CENTER_CLEARANCE: float = 30.0
const BODY_BUFFER: float = 4.0
const MAX_CORRECTION_PER_BODY_PER_TICK: float = 4.0
const EPSILON: float = 0.25

var correction_count: int = 0


func _ready() -> void:
	# Run after normal enemy motion but before the shared player/enemy clearance guard.
	process_priority = 900


func _physics_process(_delta: float) -> void:
	var enemies: Array[CharacterBody2D] = []
	for enemy_value: Node in get_tree().get_nodes_in_group("enemy"):
		if enemy_value is CharacterBody2D and _eligible_enemy(enemy_value as CharacterBody2D):
			enemies.append(enemy_value as CharacterBody2D)

	for i: int in range(enemies.size()):
		for j: int in range(i + 1, enemies.size()):
			_resolve_pair(enemies[i], enemies[j])


func _resolve_pair(a: CharacterBody2D, b: CharacterBody2D) -> void:
	if not is_instance_valid(a) or not is_instance_valid(b):
		return
	var delta := b.global_position - a.global_position
	var distance := delta.length()
	var a_extent := _body_extent(a)
	var b_extent := _body_extent(b)
	var target := maxf(MIN_CENTER_CLEARANCE, a_extent + b_extent + BODY_BUFFER)
	if distance >= target - EPSILON:
		return

	var normal: Vector2
	if distance > 0.001:
		normal = delta / distance
	else:
		# Deterministic axis prevents frame-to-frame jitter at exact coincidence.
		normal = Vector2.RIGHT if a.get_instance_id() < b.get_instance_id() else Vector2.LEFT

	# Remove only velocity that is actively driving the pair farther into one another.
	var a_inward := maxf(0.0, a.velocity.dot(normal))
	var b_inward := maxf(0.0, b.velocity.dot(-normal))
	if a_inward > 0.0:
		a.velocity -= normal * a_inward
	if b_inward > 0.0:
		b.velocity += normal * b_inward

	var penetration := target - distance
	var correction := minf(MAX_CORRECTION_PER_BODY_PER_TICK, penetration * 0.5)
	if correction <= 0.0:
		return
	a.global_position -= normal * correction
	b.global_position += normal * correction
	correction_count += 1


func _eligible_enemy(enemy: CharacterBody2D) -> bool:
	if enemy.has_meta("allow_enemy_body_overlap") and bool(enemy.get_meta("allow_enemy_body_overlap")):
		return false
	if enemy.has_method("is_dead") and bool(enemy.call("is_dead")):
		return false
	if enemy.has_method("is_deathblow_ready") and bool(enemy.call("is_deathblow_ready")):
		return false
	return STANDARD_HUSHIRO_ROLES.has(_role_for(enemy))


func _role_for(enemy: Node) -> String:
	if enemy.has_meta("presentation_role"):
		var presentation_role := str(enemy.get_meta("presentation_role")).strip_edges().to_lower()
		if not presentation_role.is_empty():
			return presentation_role
	if enemy.has_meta("hushiro_enemy_type"):
		return str(enemy.get_meta("hushiro_enemy_type")).strip_edges().to_lower()
	return ""


func _body_extent(body: CharacterBody2D) -> float:
	var collision := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision == null or collision.disabled or collision.shape == null:
		return 0.0
	var shape := collision.shape
	var extent := 0.0
	if shape is CircleShape2D:
		extent = (shape as CircleShape2D).radius
	elif shape is CapsuleShape2D:
		var capsule := shape as CapsuleShape2D
		extent = maxf(capsule.radius, capsule.height * 0.5)
	elif shape is RectangleShape2D:
		var rectangle := shape as RectangleShape2D
		extent = maxf(rectangle.size.x, rectangle.size.y) * 0.5
	if extent <= 0.0:
		return 0.0
	var scale_factor := maxf(absf(collision.global_scale.x), absf(collision.global_scale.y))
	return extent * maxf(scale_factor, 0.001)


func get_state_for_test() -> Dictionary:
	return {
		"minimum_center_clearance": MIN_CENTER_CLEARANCE,
		"body_buffer": BODY_BUFFER,
		"max_correction_per_body_per_tick": MAX_CORRECTION_PER_BODY_PER_TICK,
		"correction_count": correction_count,
	}
