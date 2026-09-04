extends Node

## Shared physical-overlap guard for player-facing enemy bodies.
##
## September 3-4 telemetry repeatedly sampled moving bosses deep inside the player's
## physical body (roughly 12-15 px center distance where the authored body extents are
## about 30 px). The attack Area2Ds should be allowed to reach the player; the enemy
## CharacterBody2D itself should not continue driving through or pinning the player.
##
## This guard is deliberately geometric rather than balance-driven:
## - clearance is derived from the live root CollisionShape2D extents;
## - attack damage/range/timing/selection are untouched;
## - only enemy-driven inward motion is corrected;
## - deathblow-ready/dead enemies are skipped so finishers are not repositioned.

const MAX_POSITION_CORRECTION_PER_TICK: float = 10.0
const PENETRATION_EPSILON: float = 0.5


func _ready() -> void:
	# Run after ordinary enemy physics so this observes the position produced by the
	# enemy's authored movement for the current physics tick.
	process_priority = 1000


func _physics_process(_delta: float) -> void:
	var player_value: Node = get_tree().get_first_node_in_group("player")
	if player_value == null or not is_instance_valid(player_value):
		return
	if not (player_value is CharacterBody2D):
		return

	var player_body := player_value as CharacterBody2D
	var player_extent := _body_extent(player_body)
	if player_extent <= 0.0:
		return

	for enemy_value in get_tree().get_nodes_in_group("enemy"):
		if enemy_value == null or not is_instance_valid(enemy_value):
			continue
		if not (enemy_value is CharacterBody2D):
			continue
		if enemy_value == player_body:
			continue

		var enemy := enemy_value as CharacterBody2D
		if _should_skip_enemy(enemy):
			continue

		var enemy_extent := _body_extent(enemy)
		if enemy_extent <= 0.0:
			continue

		var to_player := player_body.global_position - enemy.global_position
		var dist := to_player.length()
		var clearance := player_extent + enemy_extent
		if dist >= clearance - PENETRATION_EPSILON:
			continue

		var toward_player := Vector2.ZERO
		if dist > 0.001:
			toward_player = to_player / dist
		elif enemy.velocity.length_squared() > 0.001:
			toward_player = enemy.velocity.normalized()
		else:
			continue

		# Do not make the player shove stationary/retreating enemies around. This guard
		# only repairs penetration caused by the enemy moving into the player.
		var inward_speed := enemy.velocity.dot(toward_player)
		if inward_speed <= 0.01:
			continue

		enemy.velocity -= toward_player * inward_speed

		var penetration := clearance - dist
		var correction := minf(penetration, MAX_POSITION_CORRECTION_PER_TICK)
		enemy.global_position -= toward_player * correction


func _should_skip_enemy(enemy: CharacterBody2D) -> bool:
	if enemy.has_meta("allow_player_body_overlap") and bool(enemy.get_meta("allow_player_body_overlap")):
		return true

	if enemy.has_method("is_dead") and bool(enemy.call("is_dead")):
		return true

	if enemy.has_method("is_deathblow_ready") and bool(enemy.call("is_deathblow_ready")):
		return true

	return false


func _body_extent(body: CharacterBody2D) -> float:
	var collision := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision == null or collision.disabled or collision.shape == null:
		return 0.0

	var extent := _shape_extent(collision.shape)
	if extent <= 0.0:
		return 0.0

	var scale_factor := maxf(absf(collision.global_scale.x), absf(collision.global_scale.y))
	return extent * maxf(0.001, scale_factor)


func _shape_extent(shape: Shape2D) -> float:
	if shape is CircleShape2D:
		return (shape as CircleShape2D).radius

	if shape is CapsuleShape2D:
		var capsule := shape as CapsuleShape2D
		return maxf(capsule.radius, capsule.height * 0.5)

	if shape is RectangleShape2D:
		var rect := shape as RectangleShape2D
		return maxf(rect.size.x, rect.size.y) * 0.5

	# Convex/polygonal bodies are uncommon in the current enemy roster. Do not guess
	# a radius for an unknown collision primitive; leaving it untouched is safer.
	return 0.0
