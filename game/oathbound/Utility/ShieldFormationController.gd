extends Node2D
class_name ShieldFormationController

## =============================================================================
## SHIELD FORMATION CONTROLLER - v2.0 FLEE & FIGHT
## =============================================================================
## DESIGNED FOR: Large shield walls (30+ enemies) that dramatically collapse
##
## PHASE 1: All enemies form the wall (invulnerable boundary)
## PHASE 2: Random selection stay to fight, the rest FLEE and despawn
##
## This creates a dramatic "wall crumbles" moment while keeping combat fair.
## =============================================================================

# =============================================================================
# CONFIGURATION
# =============================================================================
@export_group("Formation Setup")
## Scene for a single shield enemy
@export var shield_guard_scene: PackedScene
## Number of guards in the ring (set in inspector - e.g., 36)
@export var guard_count: int = 36
## Radius of the ring around the captain
@export var radius: float = 160.0
## Path to the ShieldCaptain node
@export var captain_path: NodePath
## Start in wall mode (Phase 1)
@export var start_in_wall_mode: bool = true

@export_group("Phase 2 - Combat")
## How many enemies STAY to fight (rest flee) - RECOMMENDED: 4-5
@export var enemies_that_stay: int = 4
## Variance in how many stay (adds randomness each run)
@export var stay_variance: int = 1

@export_group("Phase 2 - Flee Timing")
## Delay before anyone starts fleeing
@export var flee_start_delay := 0.4
## Time between each fleeing enemy (staggered for drama)
@export var flee_stagger_time := 0.03
## Add slight random variance to flee timing
@export var flee_stagger_variance := 0.02

@export_group("Phase 2 - Fighter Timing")
## Delay before fighters activate (after flee starts)
@export var fighter_activation_delay := 0.6
## Stagger between each fighter activating
@export var fighter_stagger_time := 0.3

@export_group("Ring Behavior")
## Whether soldiers should slowly rotate around the ring (Phase 1 only)
@export var ring_rotates := false
## Rotation speed in degrees per second
@export var ring_rotation_speed := 5.0

# =============================================================================
# STATE
# =============================================================================
var _guards: Array[ShieldEnemy] = []
var _fighters: Array[ShieldEnemy] = []  # Enemies that stayed to fight
var _captain: Node2D = null
var _formation_broken := false
var _ring_angle_offset := 0.0
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	add_to_group("shield_formation")

	# FIX: wait one frame so ShieldCaptain has time to run _ready() and join groups
	await get_tree().process_frame

	_resolve_captain()
	_spawn_ring()
	_connect_captain_signals()
	
func _resolve_captain() -> void:
	# 1) Honor explicit captain_path if set in the inspector.
	if captain_path != NodePath(""):
		var c := get_node_or_null(captain_path)
		if c is Node2D:
			_captain = c
			return

	# 2) Prefer a ShieldCaptain by NAME within the local scene tree (most reliable).
	# This avoids group timing/order issues.
	var local := get_parent()
	if local:
		var by_name := local.find_child("ShieldCaptain", true, false)
		if by_name is Node2D:
			_captain = by_name
			return

	# 3) Fallback: search brutes (original logic)
	var brutees := get_tree().get_nodes_in_group("brute")
	var shield_candidates: Array[Node2D] = []

	for boss in brutees:
		if boss is Node2D and _is_shield_captain(boss):
			shield_candidates.append(boss)

	if shield_candidates.size() > 0:
		_captain = shield_candidates[0]
		return

	# 4) Final fallback
	for boss in brutees:
		if boss is Node2D:
			_captain = boss
			return

	_captain = null
	push_warning("[ShieldFormationController] Captain not found; ring will center on this node.")
	
func _is_shield_captain(node: Node) -> bool:
	if node == null:
		return false
	var script = node.get_script()
	if script == null or not ("resource_path" in script):
		return false
	var path := String(script.resource_path).to_lower()
	return path.contains("shield")

func _get_ring_center() -> Vector2:
	if _captain and is_instance_valid(_captain):
		return _captain.global_position
	return global_position


func _spawn_ring() -> void:
	if shield_guard_scene == null:
		push_error("[ShieldFormationController] shield_guard_scene is not assigned!")
		return
	
	var center := _get_ring_center()
	var angle_step := TAU / float(max(guard_count, 1))
	
	_guards.clear()
	_fighters.clear()
	
	for i in range(guard_count):
		var guard := shield_guard_scene.instantiate()
		
		if not guard is ShieldEnemy:
			push_warning("[ShieldFormationController] Guard scene is not ShieldEnemy type!")
			guard.queue_free()
			continue
		
		var shield_guard := guard as ShieldEnemy
		add_child(shield_guard)
		_guards.append(shield_guard)
		
		shield_guard.add_to_group("enemy")
		shield_guard.add_to_group("shield_ring")
		
		var angle := angle_step * float(i) + _ring_angle_offset
		var offset := Vector2.RIGHT.rotated(angle) * radius
		var slot_pos := center + offset
		
		shield_guard.configure_as_ring_guard(slot_pos, center, start_in_wall_mode)
		
		if not shield_guard.is_connected("ring_guard_died", Callable(self, "_on_guard_died")):
			shield_guard.connect("ring_guard_died", Callable(self, "_on_guard_died"))


func _connect_captain_signals() -> void:
	if _captain == null:
		return
	
	if _captain.has_signal("formation_broken"):
		if not _captain.is_connected("formation_broken", Callable(self, "_on_captain_formation_broken")):
			_captain.connect("formation_broken", Callable(self, "_on_captain_formation_broken"))
	
	if _captain.has_signal("defeated"):
		if not _captain.is_connected("defeated", Callable(self, "_on_captain_defeated")):
			_captain.connect("defeated", Callable(self, "_on_captain_defeated"))


# =============================================================================
# PROCESS
# =============================================================================
func _physics_process(delta: float) -> void:
	if _formation_broken:
		return
	
	if ring_rotates and not _guards.is_empty():
		_ring_angle_offset += deg_to_rad(ring_rotation_speed) * delta
		_update_ring_positions()


func _update_ring_positions() -> void:
	var center := _get_ring_center()
	var angle_step := TAU / float(max(guard_count, 1))
	
	for i in range(_guards.size()):
		var guard := _guards[i]
		if not is_instance_valid(guard):
			continue
		
		var angle := angle_step * float(i) + _ring_angle_offset
		var offset := Vector2.RIGHT.rotated(angle) * radius
		var slot_pos := center + offset
		
		guard.home = slot_pos
		guard.facing = (center - slot_pos).normalized()


# =============================================================================
# PHASE TRANSITION - THE DRAMATIC MOMENT
# =============================================================================
func _on_captain_formation_broken() -> void:
	if _formation_broken:
		return
	
	_formation_broken = true
	_break_formation_with_flee()


func _break_formation_with_flee() -> void:
	"""
	The dramatic Phase 2 transition:
	1. Randomly select which enemies stay to fight
	2. Everyone else flees outward and despawns
	3. Creates a "wall crumbling" effect
	"""
	
	# Get all living guards
	var living: Array[ShieldEnemy] = []
	for guard in _guards:
		if is_instance_valid(guard):
			living.append(guard)
	
	if living.is_empty():
		return
	
	# Shuffle for randomness
	living.shuffle()
	
	# Calculate how many stay (with variance)
	var num_stay := enemies_that_stay
	if stay_variance > 0:
		num_stay += _rng.randi_range(-stay_variance, stay_variance)
	num_stay = clamp(num_stay, 1, living.size())
	
	# Split into fighters and fleers
	var fighters: Array[ShieldEnemy] = []
	var fleers: Array[ShieldEnemy] = []
	
	for i in range(living.size()):
		if i < num_stay:
			fighters.append(living[i])
		else:
			fleers.append(living[i])
	
	_fighters = fighters
	
	# Start the dramatic sequence
	_execute_phase_transition(fighters, fleers)

func _execute_phase_transition(fighters: Array[ShieldEnemy], fleers: Array[ShieldEnemy]) -> void:
	"""Execute the flee + fight transition with immediate Phase 2 start (no initial delay)."""

	# Start fleeing immediately (no flee_start_delay)
	fleers.shuffle()

	for fleer in fleers:
		if not is_instance_valid(fleer):
			continue
		fleer.start_flee()

		# Keep stagger for drama (optional), but Phase 2 begins instantly.
		var delay := flee_stagger_time + _rng.randf() * flee_stagger_variance
		if delay > 0:
			await get_tree().create_timer(delay).timeout

	# Activate fighters immediately after fleeing begins (no fighter_activation_delay)
	for fighter in fighters:
		if not is_instance_valid(fighter):
			continue
		fighter.set_ring_wall_mode(false)
		_trigger_fighter_reaction(fighter)

		if fighter_stagger_time > 0:
			await get_tree().create_timer(fighter_stagger_time).timeout

func _trigger_fighter_reaction(guard: ShieldEnemy) -> void:
	"""Visual reaction when a fighter activates."""
	if not is_instance_valid(guard):
		return
	
	# Small outward push as they "ready up"
	var center := _get_ring_center()
	var outward := (guard.global_position - center).normalized()
	guard.knockback = outward * 60.0

func _on_captain_defeated() -> void:
	# Captain fully died - ensure transition begins.
	# IMPORTANT: do NOT force all guards into combat here,
	# because Phase 2 uses a timed flee/fight split.
	if not _formation_broken:
		_on_captain_formation_broken()

func _on_guard_died(guard: Node) -> void:
	"""Cleanup when a guard dies."""
	if guard in _guards:
		_guards.erase(guard)
	if guard in _fighters:
		_fighters.erase(guard)
	
	if _guards.is_empty() and _fighters.is_empty():
		_on_all_guards_dead()


func _on_all_guards_dead() -> void:
	"""All ring guards have been defeated or fled."""
	pass


# =============================================================================
# PUBLIC API
# =============================================================================

func get_living_guard_count() -> int:
	"""Returns number of guards still alive (not fled)."""
	var count := 0
	for guard in _guards:
		if is_instance_valid(guard):
			count += 1
	return count


func get_fighter_count() -> int:
	"""Returns number of active fighters."""
	var count := 0
	for fighter in _fighters:
		if is_instance_valid(fighter):
			count += 1
	return count


func is_formation_broken() -> bool:
	"""Returns whether the formation has transitioned to Phase 2."""
	return _formation_broken


func force_break_formation() -> void:
	"""Manually break the formation (for testing)."""
	_on_captain_formation_broken()


func get_guards() -> Array[ShieldEnemy]:
	"""Returns array of all living guards."""
	var living: Array[ShieldEnemy] = []
	for guard in _guards:
		if is_instance_valid(guard):
			living.append(guard)
	return living


func get_fighters() -> Array[ShieldEnemy]:
	"""Returns array of active fighters (enemies that stayed)."""
	var living: Array[ShieldEnemy] = []
	for fighter in _fighters:
		if is_instance_valid(fighter):
			living.append(fighter)
	return living
