extends RefCounted
class_name HushiroEnemyContract

## Shared first-playtest runtime contract for Hushiro standard enemies.
##
## Individual controllers remain responsible for authored behavior and presentation.
## This layer only normalizes the shared durability / Posture contract after legacy
## scene _ready() code and Inspector overrides have run, so imported values cannot
## silently replace docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md.

const POSTURE_RECOVER_DELAY: float = 1.5
const POSTURE_RECOVER_RATE: float = 20.0
const POSTURE_BREAK_DURATION: float = 2.5
const POSTURE_BREAK_RESET_RATIO: float = 0.50
const POSTURE_BREAK_RUNTIME = preload("res://Utility/HushiroPostureBreakRuntime.gd")

const BASELINES: Dictionary = {
	"hollow": {"health": 60, "posture": 50.0},
	"hound": {"health": 65, "posture": 60.0},
	"archer": {"health": 75, "posture": 65.0},
	"swordsman": {"health": 100, "posture": 100.0},
	"bilemass": {"health": 80, "posture": 70.0},
	"warden": {"health": 140, "posture": 150.0},
}


static func apply(enemy: Node, enemy_type: String) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return

	var key: String = enemy_type.to_lower()
	if not BASELINES.has(key):
		return

	var baseline: Dictionary = BASELINES[key]
	var health: int = int(baseline.health)
	var posture_max: float = float(baseline.posture)

	enemy.set_meta("hushiro_enemy_type", key)
	enemy.set_meta("hushiro_contract", "area1_first_playtest")

	_set_property_if_present(enemy, "hp", health)
	_set_property_if_present(enemy, "_max_hp", health)

	# Keep controller-owned exported defaults in sync as well. This matters for
	# direct Playtest Lab spawns and for any controller that reapplies its defaults.
	match key:
		"hollow":
			_set_property_if_present(enemy, "hollow_hp", health)
		"archer":
			pass
		"bilemass":
			_set_property_if_present(enemy, "bilemass_hp", health)
		"warden":
			_set_property_if_present(enemy, "warden_hp", health)

	# Hound still owns a small local Posture bridge. Normalize that bridge when it
	# exists, while all other enemies use the shared CombatController configuration.
	_set_property_if_present(enemy, "max_posture", posture_max)
	_set_property_if_present(enemy, "posture", 0.0)
	_set_property_if_present(enemy, "posture_recovery_delay", POSTURE_RECOVER_DELAY)
	_set_property_if_present(enemy, "posture_decay_rate", POSTURE_RECOVER_RATE)
	_set_property_if_present(enemy, "posture_break_duration", POSTURE_BREAK_DURATION)

	var combat: Node = enemy.get_node_or_null("Combat")
	if combat != null:
		var cfg_value: Variant = combat.get("config")
		var cfg: CombatConfig = cfg_value as CombatConfig
		if cfg == null:
			cfg = CombatConfig.new()
		else:
			# Scene resources may be shared by multiple instances. Never mutate the
			# imported resource in place when authoring an enemy-specific Posture max.
			cfg = cfg.duplicate(true) as CombatConfig

		cfg.posture_max = posture_max
		cfg.posture_recover_delay = POSTURE_RECOVER_DELAY
		cfg.posture_recover_rate = POSTURE_RECOVER_RATE
		cfg.posture_break_duration = POSTURE_BREAK_DURATION
		cfg.posture_break_reset_ratio = POSTURE_BREAK_RESET_RATIO
		combat.set("config", cfg)
		combat.set("_posture", 0.0)

	_attach_posture_break_runtime(enemy, key)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_enemy_contract_applied", {
			"enemy_type": key,
			"enemy_id": enemy.get_instance_id(),
			"health": health,
			"posture_max": posture_max,
			"posture_recover_delay": POSTURE_RECOVER_DELAY,
			"posture_recover_rate": POSTURE_RECOVER_RATE,
			"posture_break_duration": POSTURE_BREAK_DURATION,
			"posture_break_runtime": true,
		})


static func _attach_posture_break_runtime(enemy: Node, enemy_type: String) -> void:
	if enemy.get_node_or_null("HushiroPostureBreakRuntime") != null:
		return
	var runtime: Node = POSTURE_BREAK_RUNTIME.new()
	runtime.name = "HushiroPostureBreakRuntime"
	if runtime.has_method("configure"):
		runtime.call("configure", enemy, enemy_type)
	enemy.add_child(runtime)


static func _set_property_if_present(object: Object, property_name: String, value: Variant) -> void:
	for property_data: Dictionary in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			object.set(property_name, value)
			return
