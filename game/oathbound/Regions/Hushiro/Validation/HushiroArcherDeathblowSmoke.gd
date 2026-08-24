extends Node

## Regression for the manual 2026-08-23 Hushiro playtest blockers:
## - a Corrupted Archer must actually die when a valid Deathblow executes;
## - reaching 65/65 Posture must enter a real stagger before the finisher arms.

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

	if not archer_value.has_method("is_deathblow_ready"):
		_fail("canonical Archer has no is_deathblow_ready contract")
		return
	if not archer_value.has_method("receive_deathblow"):
		_fail("canonical Archer has no receive_deathblow contract")
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
		_fail("expected Archer posture_max=65, got %.3f" % posture_max)
		return

	var break_runtime: Node = archer_value.get_node_or_null("HushiroPostureBreakRuntime")
	if break_runtime == null:
		_fail("canonical Archer missing shared posture-break runtime")
		return

	combat_controller.add_posture(posture_max)
	await get_tree().physics_frame

	if combat_controller.get_posture_ratio() < 0.999:
		_fail("Archer did not reach full Posture")
		return
	if not bool(break_runtime.call("is_break_active")):
		_fail("full-Posture Archer did not enter posture-broken stagger")
		return
	if bool(archer_value.call("is_deathblow_ready")):
		_fail("Archer became Deathblow-ready on the same frame as Posture break")
		return

	await get_tree().create_timer(0.24).timeout
	await get_tree().physics_frame

	if not bool(archer_value.call("is_deathblow_ready")):
		_fail("staggered Archer did not become Deathblow-ready after readability beat")
		return

	archer_value.connect("enemy_died", Callable(self, "_on_enemy_died"))
	archer_value.call("receive_deathblow", null)

	if _death_signal_count != 1:
		_fail("deathblow did not synchronously resolve exactly one Archer death")
		return
	if bool(archer_value.call("is_deathblow_ready")):
		_fail("dead Archer remained Deathblow-ready")
		return

	print("[HushiroArcherDeathblowSmoke] PASS - 65/65 Posture -> deathblow -> enemy_died")
	get_tree().quit(0)


func _on_enemy_died(_enemy: Node) -> void:
	_death_signal_count += 1


func _fail(message: String) -> void:
	push_error("[HushiroArcherDeathblowSmoke] FAIL - %s" % message)
	get_tree().quit(1)
