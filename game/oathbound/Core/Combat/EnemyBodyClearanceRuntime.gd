extends Node

## Shared physical-overlap guard for player-facing enemy bodies.
##
## September 3-4 telemetry repeatedly sampled moving bosses deep inside the player's
## physical body. A later September 8 replay proved that always correcting penetration
## by relocating the enemy fixed sticking but let Akio bulldoze stationary enemies and
## bosses: zero-authored-velocity enemies moved almost one-for-one with the Player.
##
## This guard is deliberately geometric rather than balance-driven:
## - clearance is derived from the live root CollisionShape2D extents plus a small
##   top-down body buffer supported by the observed sticky-contact distance;
## - enemy CharacterBody2D motion mode is normalized to FLOATING for top-down combat;
## - attack damage/range/timing/selection are untouched;
## - inward velocity is removed from whichever body is driving into the contact;
## - normal depenetration moves the body responsible for the stronger inward drive;
## - a stationary/pre-existing overlap anchors the enemy and moves Akio out instead of
##   translating the enemy, preventing player-driven boss dragging;
## - deathblow-ready/dead enemies are skipped so finishers are not repositioned.

const MAX_POSITION_CORRECTION_PER_TICK: float = 10.0
const PENETRATION_EPSILON: float = 0.5
const BODY_CLEARANCE_BUFFER: float = 8.0
const INWARD_SPEED_EPSILON: float = 0.01


func _ready() -> void:
	# Run after ordinary enemy/player physics so this observes the positions produced by
	# authored movement and Godot contact recovery for the current physics tick.
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
		# All current combat is top-down. Leaving imported/bespoke enemies in the
		# CharacterBody2D default grounded mode gives Godot platform-style floor/wall
		# contact classification that can contribute to sticky body recovery.
		if enemy.motion_mode != CharacterBody2D.MOTION_MODE_FLOATING:
			enemy.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

		if _should_skip_enemy(enemy):
			continue

		var enemy_extent := _body_extent(enemy)
		if enemy_extent <= 0.0:
			continue

		_resolve_pair_clearance(player_body, player_extent, enemy, enemy_extent)


func _resolve_pair_clearance(
	player_body: CharacterBody2D,
	player_extent: float,
	enemy: CharacterBody2D,
	enemy_extent: float
) -> void:
	var to_player: Vector2 = player_body.global_position - enemy.global_position
	var dist: float = to_player.length()
	var clearance: float = player_extent + enemy_extent + BODY_CLEARANCE_BUFFER
	if dist >= clearance - PENETRATION_EPSILON:
		return

	var toward_player := Vector2.ZERO
	if dist > 0.001:
		toward_player = to_player / dist
	elif player_body.velocity.length_squared() > 0.001:
		# If Akio drove into exact coincidence, away-from-enemy is opposite his inward
		# travel. This preserves stable player authority even at a zero-distance sample.
		toward_player = -player_body.velocity.normalized()
	elif enemy.velocity.length_squared() > 0.001:
		toward_player = enemy.velocity.normalized()
	else:
		# Perfectly coincident stationary bodies have no geometric direction. Keep the
		# enemy authoritative and eject Akio along a deterministic axis.
		toward_player = Vector2.RIGHT

	# `toward_player` points enemy -> player. Enemy inward movement therefore projects
	# positively onto it, while player inward movement projects positively onto its
	# inverse. Capture both before mutating either velocity so correction authority is
	# based on authored motion for this tick.
	var enemy_inward_speed: float = maxf(0.0, enemy.velocity.dot(toward_player))
	var player_inward_speed: float = maxf(0.0, player_body.velocity.dot(-toward_player))

	if enemy_inward_speed > INWARD_SPEED_EPSILON:
		enemy.velocity -= toward_player * enemy_inward_speed
	if player_inward_speed > INWARD_SPEED_EPSILON:
		player_body.velocity += toward_player * player_inward_speed

	var penetration: float = clearance - dist
	var correction: float = minf(penetration, MAX_POSITION_CORRECTION_PER_TICK)

	# Attribute overlap recovery to the stronger inward drive. This keeps enemy-authored
	# lunges from carrying Akio while preventing player-authored movement from translating
	# a stationary boss. Ties and zero-velocity/pre-existing overlaps favor the enemy as
	# the obstacle and move the player out.
	if enemy_inward_speed > player_inward_speed + INWARD_SPEED_EPSILON:
		enemy.global_position -= toward_player * correction
	else:
		player_body.global_position += toward_player * correction


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
