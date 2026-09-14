extends Node

## Regression for the current standard-enemy defense contract:
## - Corrupted Archer retains its Health-first durability baseline;
## - legacy Posture compatibility values cannot accumulate into a break;
## - standard Archer never becomes Deathblow-ready from Posture;
## - the canonical death path still emits exactly one enemy_died signal.

const ARCHER_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcher.tscn")

var _death_signal_count: int = 0


func _ready() -> void:
	call_deferred("_run_contract")


func _run_contract() -> void:
	var archer_value: Node = ARCHER_SCENE.instantiate()
	if archer_value == null:
		_fail("could not instantiate canonical Corrupted Archer")
		return

	add_child(archer_value)
	await get_tree().process_frame
	await get_tree().physics_frame

	if not archer_value.has_method("is_deathblow_ready"):
		_fail("canonical Archer has no compatibility is_deathblow_ready contract")
		return
	if not archer_value.has_signal("enemy_died"):
		_fail("canonical Archer has no enemy_died signal")
		return

	var combat_value: Variant = archer_value.get("combat")
	if not (combat_value is CombatController):
		_fail("canonical Archer has no CombatController")
		return
	var combat_controller: CombatController = combat_value as CombatController
	if combat_controller.config == null:
		_fail("canonical Archer CombatController has no config")
		return

	var posture_max: float = combat_controller.config.posture_max
	if absf(posture_max - 65.0) > 0.001:
		_fail("expected Archer legacy compatibility posture_max=65, got %.3f" % posture_max)
		return

	var no_posture: Node = archer_value.get_node_or_null("HushiroStandardNoPostureRuntime")
	if no_posture == null:
		_fail("canonical Archer missing standard no-Posture runtime")
		return
	if no_posture.has_method("is_posture_retired") and not bool(no_posture.call("is_posture_retired")):
		_fail("canonical Archer no-Posture runtime is not active")
		return
	if archer_value.get_node_or_null("HushiroPostureBreakRuntime") != null:
		_fail("canonical Archer still owns retired standard posture-break runtime")
		return
	if archer_value.get_node_or_null("HushiroPostureReadabilityRuntime") != null:
		_fail("canonical Archer still owns retired standard Posture readability runtime")
		return

	combat_controller.add_posture(posture_max)
	await get_tree().physics_frame
	if not is_zero_approx(combat_controller.get_posture()):
		_fail("Archer accumulated retired standard Posture")
		return
	if bool(archer_value.call("is_deathblow_ready")):
		_fail("standard Archer became Deathblow-ready after retired Posture input")
		return

	var posture_bar: Node = archer_value.get_node_or_null("PostureBar")
	if posture_bar is CanvasItem and (posture_bar as CanvasItem).visible:
		_fail("standard Archer PostureBar is still visible")
		return

	archer_value.connect("enemy_died", Callable(self, "_on_enemy_died"))
	archer_value.call("death")
	if _death_signal_count != 1:
		_fail("canonical Archer death path did not synchronously emit exactly one enemy_died signal")
		return

	print("[HushiroArcherDeathblowSmoke] PASS - Health defeat | Posture retired | no standard Deathblow")
	get_tree().quit(0)


func _on_enemy_died(_enemy: Node) -> void:
	_death_signal_count += 1


func _fail(message: String) -> void:
	push_error("[HushiroArcherDeathblowSmoke] FAIL - %s" % message)
	get_tree().quit(1)