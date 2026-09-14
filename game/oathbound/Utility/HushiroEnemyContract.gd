extends RefCounted
class_name HushiroEnemyContract

## Shared playtest runtime contract for Hushiro standard enemies.
##
## Individual controllers remain responsible for authored behavior and presentation.
## This layer normalizes shared durability after legacy scene _ready() code and Inspector
## overrides have run. Standard-enemy Posture/Deathblow ownership is retired: the old
## Posture values remain as compatibility configuration only for imported controllers.

const CONTRACT_REVISION: int = 3
const POSTURE_RECOVER_DELAY: float = 1.5
const POSTURE_RECOVER_RATE: float = 20.0
const POSTURE_BREAK_DURATION: float = 2.5
const POSTURE_BREAK_RESET_RATIO: float = 0.50
const NO_POSTURE_RUNTIME = preload("res://Utility/HushiroStandardNoPostureRuntime.gd")
const HOUND_COMBAT_RUNTIME = preload("res://Utility/HushiroHoundCombatRuntime.gd")

# BlightedHound still contains an imported local posture-break trigger. Keep that local
# trigger unreachable while the no-Posture runtime zeros its compatibility meter.
const HOUND_LEGACY_POSTURE_GUARD_MAX: float = 10000.0

const BASELINES: Dictionary = {
	# Area 1 hack-and-slash calibration is anchored to the pre-awakening base-katana
	# 9 -> 12 -> 21 sequence: 42 damage after three hits, 51 after four, 63 after five.
	# `posture` values are retained only as legacy scene/config compatibility data; they
	# are not a standard-enemy kill, stagger, UI, or Deathblow gate anymore.
	"hollow": {"health": 40, "posture": 40.0},
	"hound": {"health": 50, "posture": 45.0},
	"archer": {"health": 45, "posture": 65.0},
	"swordsman": {"health": 60, "posture": 90.0},
	"bilemass": {"health": 60, "posture": 70.0},
	# Warden remains the deliberate durable standard-enemy exception by Health/role.
	"warden": {"health": 140, "posture": 150.0},
}

const CLOSE_PRESSURE_TYPES: Array[String] = ["swordsman", "hollow", "hound", "warden"]


static func apply(enemy: Node, enemy_type: String, force: bool = false) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return

	var key: String = enemy_type.to_lower()
	if not BASELINES.has(key):
		return

	# HushiroEnemyRuntime has two legitimate discovery paths: node_added for new spawns
	# and a deferred sweep for actors that already existed when the runtime initialized.
	if not force and is_current_contract(enemy, key):
		return

	var baseline: Dictionary = BASELINES[key]
	var health: int = int(baseline.health)
	var posture_max: float = float(baseline.posture)

	enemy.set_meta("hushiro_enemy_type", key)
	enemy.set_meta("hushiro_contract", "area1_player_paced_combat")
	enemy.set_meta("oathbound_standard_posture_retired", true)
	apply_pressure_metadata(enemy, key)

	_set_property_if_present(enemy, "hp", health)
	_set_property_if_present(enemy, "_max_hp", health)

	# Keep controller-owned exported defaults in sync as well. This matters for direct
	# Playtest Lab spawns and controllers that reapply their imported defaults.
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

	# Imported fields remain normalized so legacy code cannot accidentally trip a local
	# meter before the shared no-Posture boundary has a chance to zero it.
	if key == "hound":
		_set_property_if_present(enemy, "max_posture", HOUND_LEGACY_POSTURE_GUARD_MAX)
	else:
		_set_property_if_present(enemy, "max_posture", posture_max)
	_set_property_if_present(enemy, "posture", 0.0)
	_set_property_if_present(enemy, "posture_recovery_delay", POSTURE_RECOVER_DELAY)
	_set_property_if_present(enemy, "posture_decay_rate", POSTURE_RECOVER_RATE)
	_set_property_if_present(enemy, "posture_break_duration", POSTURE_BREAK_DURATION)
	_set_property_if_present(enemy, "_dbroken_active", false)

	var combat: Node = enemy.get_node_or_null("Combat")
	if combat != null:
		var cfg_value: Variant = combat.get("config")
		var cfg: CombatConfig = cfg_value as CombatConfig
		if cfg == null:
			cfg = CombatConfig.new()
		else:
			# Scene resources may be shared by multiple instances. Never mutate the
			# imported resource in place when preserving compatibility values.
			cfg = cfg.duplicate(true) as CombatConfig

		cfg.posture_max = posture_max
		cfg.posture_recover_delay = POSTURE_RECOVER_DELAY
		cfg.posture_recover_rate = POSTURE_RECOVER_RATE
		cfg.posture_break_duration = POSTURE_BREAK_DURATION
		cfg.posture_break_reset_ratio = POSTURE_BREAK_RESET_RATIO
		combat.set("config", cfg)
		combat.set("_posture", 0.0)
		combat.set("_break_until_ts", -1.0)

	_attach_no_posture_runtime(enemy)
	if key == "hound":
		_attach_hound_combat_runtime(enemy)

	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")

	# Set the install marker only after normalization/runtime attachment completes so a
	# partial path can never masquerade as a successful current contract.
	var application_count: int = int(enemy.get_meta("hushiro_contract_apply_count", 0)) + 1
	enemy.set_meta("hushiro_contract_revision", CONTRACT_REVISION)
	enemy.set_meta("hushiro_contract_enemy_type", key)
	enemy.set_meta("hushiro_contract_apply_count", application_count)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_enemy_contract_applied", {
			"enemy_type": key,
			"enemy_id": enemy.get_instance_id(),
			"health": health,
			"legacy_posture_max": posture_max,
			"standard_posture_retired": true,
			"posture_break_runtime": false,
			"posture_readability_runtime": false,
			"hound_shared_posture_bridge": key == "hound",
			"v2_pressure_migrated": true,
			"frontline_pressure_body": bool(enemy.get_meta("oathbound_frontline_pressure_body", true)),
			"pressure_role": str(enemy.get_meta("oathbound_pressure_role", "melee")),
			"kill_time_contract": "area1_player_paced",
			"contract_revision": CONTRACT_REVISION,
			"application_count": application_count,
		})


static func is_current_contract(enemy: Node, enemy_type: String) -> bool:
	if enemy == null or not is_instance_valid(enemy):
		return false
	var key: String = enemy_type.to_lower()
	return (
		int(enemy.get_meta("hushiro_contract_revision", 0)) == CONTRACT_REVISION
		and str(enemy.get_meta("hushiro_contract_enemy_type", "")) == key
	)


static func apply_pressure_metadata(enemy: Node, enemy_type: String) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	var key: String = enemy_type.to_lower()
	if not BASELINES.has(key):
		return

	# AttackDirector remains compatibility infrastructure around Combat V2. These
	# metadata keys distinguish close-frontline bodies from ranged/spatial actors.
	enemy.set_meta("oathbound_v2_pressure_migrated", true)
	enemy.set_meta("oathbound_frontline_pressure_body", is_frontline_pressure_type(key))
	enemy.set_meta("oathbound_pressure_role", pressure_role_for_type(key))


static func is_frontline_pressure_type(enemy_type: String) -> bool:
	return CLOSE_PRESSURE_TYPES.has(enemy_type.to_lower())


static func pressure_role_for_type(enemy_type: String) -> String:
	match enemy_type.to_lower():
		"archer":
			return "ranged"
		"bilemass":
			return "hazard"
		"warden":
			return "control"
		_:
			return "melee"


static func _apply_hound_tuning(enemy: Node) -> void:
	# Keep the pack-rusher identity, but make each commitment readable and punishable.
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


static func _attach_no_posture_runtime(enemy: Node) -> void:
	if enemy.get_node_or_null("HushiroStandardNoPostureRuntime") != null:
		return
	var runtime: Node = NO_POSTURE_RUNTIME.new()
	runtime.name = "HushiroStandardNoPostureRuntime"
	if runtime.has_method("configure"):
		runtime.call("configure", enemy)
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
