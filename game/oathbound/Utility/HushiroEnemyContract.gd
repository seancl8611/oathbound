extends RefCounted
class_name HushiroEnemyContract

## Shared playtest runtime contract for Hushiro standard enemies.
##
## Individual controllers remain responsible for authored behavior and presentation.
## This layer normalizes shared durability / Posture after legacy scene _ready() code
## and Inspector overrides have run, so imported values cannot silently replace the
## current playtest baseline.

const POSTURE_RECOVER_DELAY: float = 1.5
const POSTURE_RECOVER_RATE: float = 20.0
const POSTURE_BREAK_DURATION: float = 2.5
const POSTURE_BREAK_RESET_RATIO: float = 0.50
const POSTURE_BREAK_RUNTIME = preload("res://Utility/HushiroPostureBreakRuntime.gd")
const HOUND_COMBAT_RUNTIME = preload("res://Utility/HushiroHoundCombatRuntime.gd")

# BlightedHound still contains an imported local posture-break trigger. The shared
# CombatController is now authoritative, so keep the old local trigger unreachable and
# let HushiroHoundCombatRuntime mirror the real value back to its existing UI.
const HOUND_LEGACY_POSTURE_GUARD_MAX: float = 10000.0

const BASELINES: Dictionary = {
	# Hollows are true swarm fodder: Akio should cut them down quickly rather than spend
	# a full duel's worth of inputs on each body.
	"hollow": {"health": 45, "posture": 40.0},
	# Hounds are fast pressure pieces, not tanks. One clean parry plus a normal sword
	# punish now breaks their 45 Posture shared meter.
	"hound": {"health": 50, "posture": 45.0},
	"archer": {"health": 75, "posture": 65.0},
	# Swordsmen remain the Area 1 duel anchor, but 90/90 gives Akio a practical burst
	# line through parry + held/basic pressure instead of an overly long attrition duel.
	"swordsman": {"health": 90, "posture": 90.0},
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
	enemy.set_meta("hushiro_contract", "area1_combat_stabilization")

	_set_property_if_present(enemy, "hp", health)
	_set_property_if_present(enemy, "_max_hp", health)

	# Keep controller-owned exported defaults in sync as well. This matters for
	# direct Playtest Lab spawns and for any controller that reapplies its defaults.
	match key:
		"hollow":
			_set_property_if_present(enemy, "hollow_hp", health)
		"hound":
			_apply_hound_tuning(enemy)
		"archer":
			pass
		"bilemass":
			_set_property_if_present(enemy, "bilemass_hp", health)
		"warden":
			_set_property_if_present(enemy, "warden_hp", health)

	# The Hound's old local meter is now only an input bridge for its imported parry
	# callback. Other enemies already use CombatController directly.
	if key == "hound":
		_set_property_if_present(enemy, "max_posture", HOUND_LEGACY_POSTURE_GUARD_MAX)
	else:
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
	if key == "hound":
		_attach_hound_combat_runtime(enemy)

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
			"hound_shared_posture_bridge": key == "hound",
		})


static func _apply_hound_tuning(enemy: Node) -> void:
	# Keep the pack-rusher identity, but make each commitment readable and punishable.
	# The encounter director controls concurrency; these values control one Hound's turn.
	_set_property_if_present(enemy, "movement_speed", 75.0)
	_set_property_if_present(enemy, "lunge_speed", 235.0)
	_set_property_if_present(enemy, "lunge_windup", 0.55)
	_set_property_if_present(enemy, "bite_windup", 0.38)
	_set_property_if_present(enemy, "lunge_active_time", 0.24)
	_set_property_if_present(enemy, "recover_time", 1.00)
	_set_property_if_present(enemy, "lunge_cd", 4.00)
	_set_property_if_present(enemy, "bite_cd", 2.40)
	_set_property_if_present(enemy, "attack_cd", 1.05)
	_set_property_if_present(enemy, "hold_distance", 82.0)
	_set_property_if_present(enemy, "orbit_speed", 50.0)
	_set_property_if_present(enemy, "parry_posture_gain", 35.0)


static func _attach_posture_break_runtime(enemy: Node, enemy_type: String) -> void:
	if enemy.get_node_or_null("HushiroPostureBreakRuntime") != null:
		return
	var runtime: Node = POSTURE_BREAK_RUNTIME.new()
	runtime.name = "HushiroPostureBreakRuntime"
	if runtime.has_method("configure"):
		runtime.call("configure", enemy, enemy_type)
	enemy.add_child(runtime)


static func _attach_hound_combat_runtime(enemy: Node) -> void:
	if enemy.get_node_or_null("HushiroHoundCombatRuntime") != null:
		return
	var runtime: Node = HOUND_COMBAT_RUNTIME.new()
	runtime.name = "HushiroHoundCombatRuntime"
	if runtime.has_method("configure"):
		runtime.call("configure", enemy)
	enemy.add_child(runtime)


static func _set_property_if_present(object: Object, property_name: String, value: Variant) -> void:
	for property_data: Dictionary in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			object.set(property_name, value)
			return
