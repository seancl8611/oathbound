extends "res://Utility/ProstheticExecutor.gd"

## Current Oathbound Prosthetic combat authority.
##
## The imported executor remains available as compatibility/reference code, but this
## layer owns the approved first-playtest Spirit, timing, cooldown, geometry, status,
## control, and upgrade behavior from docs/gameplay/PROSTHETICS.md.
##
## Important boundaries:
## - 100 shared Spirit, no passive regeneration.
## - Cooldown begins when the Prosthetic action finishes and control returns.
## - Current Prosthetic damage has 0 ordinary Technique proc coefficient.
## - Current statuses do not use the imported Shock-as-stun/posture-DoT semantics.

const CURRENT_RUNTIME_VERSION: String = "1.0"
const SPIRIT_MAX: int = 100
const ENEMY_MASK: int = 4
const WORLD_MASK: int = 1
const SMOKE_ATTACK_DISTANCE: float = 50.0

const CONFIG: Dictionary = {
	"beast_whistle": {"startup": 0.18, "recovery": 0.25, "cooldown": 3.0},
	"thunder_rod": {"startup": 0.24, "recovery": 0.32, "cooldown": 3.0},
	"smoke_gourd": {"startup": 0.25, "recovery": 0.30, "cooldown": 7.0},
	"fang_harpoon": {"startup": 0.22, "recovery": 0.32, "cooldown": 2.5},
	"mirror_umbrella": {"startup": 0.10, "recovery": 0.25, "cooldown": 4.5},
	"flame_vent": {"startup": 0.25, "recovery": 0.35, "cooldown": 3.5},
	"mist_raven": {"startup": 0.06, "recovery": 0.16, "cooldown": 4.5},
	"bloodletting_gourd": {"startup": 0.30, "recovery": 0.30, "cooldown": 8.0},
}

var _action_elapsed: float = 0.0
var _effect_fired: bool = false
var _activation_direction: Vector2 = Vector2.RIGHT
var _umbrella_phase: String = ""
var _umbrella_storage: float = 0.0
var _umbrella_capacity: float = 50.0
var _burn_states: Dictionary = {}
var _smoke_state: Dictionary = {}


func _ready() -> void:
	max_spirit = SPIRIT_MAX
	current_spirit = SPIRIT_MAX
	_active_prosthetic_id = ""
	_use_timer = 0.0
	_cooldown_timer = 0.0
	_cooldown_total = 0.0
	print("[OathboundProstheticExecutor] v%s - canonical 100 Spirit runtime" % CURRENT_RUNTIME_VERSION)
	_record("prosthetic_runtime_ready", {
		"script": get_script().resource_path if get_script() is Script else "",
		"spirit": current_spirit,
		"spirit_max": max_spirit,
	})


func setup(player: CharacterBody2D, combat_controller: CombatController) -> void:
	_owner_player = player
	_combat = combat_controller
	if _combat != null and _combat.has_signal("prosthetic_started"):
		var callable := Callable(self, "_on_prosthetic_requested")
		if not _combat.is_connected("prosthetic_started", callable):
			_combat.connect("prosthetic_started", callable)


func _physics_process(delta: float) -> void:
	_tick_cooldown(delta)
	_tick_burn(delta)
	_tick_smoke()

	if _active_prosthetic_id.is_empty():
		return

	_action_elapsed += delta
	if _active_prosthetic_id == "mirror_umbrella":
		_tick_umbrella_action()
		return

	var cfg: Dictionary = CONFIG.get(_active_prosthetic_id, {})
	var startup: float = float(cfg.get("startup", 0.0))
	var recovery: float = float(cfg.get("recovery", 0.0))
	if not _effect_fired and _action_elapsed >= startup:
		_effect_fired = true
		_execute_current_effect(_active_prosthetic_id)
	if _action_elapsed >= startup + recovery:
		_finish_current_prosthetic()


func _on_prosthetic_requested() -> void:
	if not _active_prosthetic_id.is_empty() or _cooldown_timer > 0.0:
		return
	var prosthetic_id: String = str(ProstheticManager.equipped_prosthetic_id)
	if prosthetic_id.is_empty() or not CONFIG.has(prosthetic_id):
		return
	var data: ProstheticData = ProstheticManager.get_prosthetic(prosthetic_id)
	if data == null:
		return

	var cost: int = _effective_spirit_cost(prosthetic_id)
	if current_spirit < cost:
		_record("prosthetic_use_rejected", {
			"prosthetic_id": prosthetic_id,
			"reason": "insufficient_spirit",
			"spirit": current_spirit,
			"cost": cost,
		})
		return

	current_spirit -= cost
	spirit_changed.emit(current_spirit, max_spirit)
	_active_prosthetic_id = prosthetic_id
	_action_elapsed = 0.0
	_effect_fired = false
	_activation_direction = _get_current_aim_direction()
	_use_timer = 1.0
	if _combat != null:
		_combat.set_using_prosthetic(true)

	if prosthetic_id == "mirror_umbrella":
		_umbrella_phase = "startup"
		_umbrella_storage = 0.0
		_umbrella_capacity = 70.0 if ProstheticManager.is_upgrade_purchased(prosthetic_id, "reinforced_canopy") else 50.0

	prosthetic_used.emit(prosthetic_id)
	_record("prosthetic_use_started", {
		"prosthetic_id": prosthetic_id,
		"spirit_cost": cost,
		"spirit_after": current_spirit,
		"aim": [_activation_direction.x, _activation_direction.y],
	})


func _finish_current_prosthetic() -> void:
	if _active_prosthetic_id.is_empty():
		return
	var finished_id: String = _active_prosthetic_id
	if finished_id == "mirror_umbrella" and _umbrella_phase == "active":
		_close_umbrella()
		return

	var cfg: Dictionary = CONFIG.get(finished_id, {})
	var cooldown: float = float(cfg.get("cooldown", base_cooldown))
	_active_prosthetic_id = ""
	_use_timer = 0.0
	_action_elapsed = 0.0
	_effect_fired = false
	_umbrella_phase = ""
	if _owner_player != null:
		_owner_player.set_meta("_oathbound_umbrella_active", false)
	if _combat != null:
		_combat.set_using_prosthetic(false)
		_combat.start_prosthetic_cooldown(cooldown)
	_cooldown_timer = cooldown
	_cooldown_total = cooldown
	prosthetic_finished.emit(finished_id)
	_record("prosthetic_use_finished", {
		"prosthetic_id": finished_id,
		"cooldown": cooldown,
		"spirit": current_spirit,
	})


func _tick_cooldown(delta: float) -> void:
	if _cooldown_timer <= 0.0:
		return
	_cooldown_timer = maxf(0.0, _cooldown_timer - delta)


func _tick_umbrella_action() -> void:
	var cfg: Dictionary = CONFIG["mirror_umbrella"]
	var startup: float = float(cfg.get("startup", 0.10))
	var recovery: float = float(cfg.get("recovery", 0.25))
	match _umbrella_phase:
		"startup":
			if _action_elapsed >= startup:
				_umbrella_phase = "active"
				_action_elapsed = 0.0
				if _owner_player != null:
					_owner_player.set_meta("_oathbound_umbrella_active", true)
				_record("prosthetic_umbrella_open", {"capacity": _umbrella_capacity})
		"active":
			if not Input.is_action_pressed("prosthetic") or _action_elapsed >= 1.25:
				_close_umbrella()
		"recovery":
			if _action_elapsed >= recovery:
				_finish_current_prosthetic()


func _close_umbrella() -> void:
	if _umbrella_phase != "active":
		return
	if _owner_player != null:
		_owner_player.set_meta("_oathbound_umbrella_active", false)
	_release_umbrella_pressure()
	_umbrella_phase = "recovery"
	_action_elapsed = 0.0
	_record("prosthetic_umbrella_close", {"stored_pressure": _umbrella_storage})


func try_umbrella_absorb(dmg: int, dmg_type: String, attacker: Node) -> bool:
	if _active_prosthetic_id != "mirror_umbrella" or _umbrella_phase != "active":
		return false
	if _owner_player == null or not bool(_owner_player.get_meta("_oathbound_umbrella_active", false)):
		return false
	if dmg_type in ["grab", "mass", "unblockable", "perilous"]:
		return false

	var attacker_position: Vector2 = _owner_player.global_position
	if attacker is Node2D:
		attacker_position = (attacker as Node2D).global_position
	if attacker is Area2D and attacker.has_meta("attacker"):
		var source_value: Variant = attacker.get_meta("attacker")
		if source_value is Node2D and is_instance_valid(source_value):
			attacker_position = (source_value as Node2D).global_position

	var incoming_dir: Vector2 = (attacker_position - _owner_player.global_position).normalized()
	var facing: Vector2 = _activation_direction
	if _owner_player.has_method("get_defensive_facing"):
		facing = Vector2(_owner_player.call("get_defensive_facing"))
	if facing.length() < 0.01:
		facing = Vector2.RIGHT
	var angle_degrees: float = absf(rad_to_deg(facing.normalized().angle_to(incoming_dir)))
	if angle_degrees > 90.0:
		return false

	var block_posture: float = float(dmg)
	if attacker != null and attacker.has_meta("block_posture_damage"):
		block_posture = maxf(0.0, float(attacker.get_meta("block_posture_damage")))
	var remaining_capacity: float = maxf(0.0, _umbrella_capacity - _umbrella_storage)
	if block_posture > remaining_capacity + 0.001:
		_record("prosthetic_umbrella_overflow", {
			"incoming_block_posture": block_posture,
			"remaining_capacity": remaining_capacity,
		})
		return false

	_umbrella_storage += block_posture
	if _owner_player.has_method("apply_umbrella_posture"):
		_owner_player.call("apply_umbrella_posture", block_posture * 0.25)
	_record("prosthetic_umbrella_absorb", {
		"incoming_block_posture": block_posture,
		"stored_pressure": _umbrella_storage,
		"capacity": _umbrella_capacity,
		"angle_degrees": angle_degrees,
	})
	return true


func _release_umbrella_pressure() -> void:
	if _owner_player == null or _umbrella_storage <= 0.0:
		_umbrella_storage = 0.0
		return
	var weighted: bool = ProstheticManager.is_upgrade_purchased("mirror_umbrella", "weighted_release")
	var release_ratio: float = 1.0 if weighted else 0.75
	var release_cap: float = 55.0 if weighted else 38.0
	var posture: float = minf(release_cap, _umbrella_storage * release_ratio)
	var targets: Array[Node] = _targets_in_cone(_owner_player.global_position, _activation_direction, 90.0, 180.0)
	for target: Node in targets:
		_apply_canonical_contact(target, 0, posture, "mirror_umbrella_release")
	_record("prosthetic_umbrella_release", {
		"stored_pressure": _umbrella_storage,
		"posture_pressure": posture,
		"target_count": targets.size(),
	})
	_umbrella_storage = 0.0


func _execute_current_effect(prosthetic_id: String) -> void:
	match prosthetic_id:
		"beast_whistle":
			_use_current_beast_whistle()
		"thunder_rod":
			_use_current_thunder_rod()
		"smoke_gourd":
			_use_current_smoke_gourd()
		"fang_harpoon":
			_use_current_fang_harpoon()
		"flame_vent":
			_use_current_flame_vent()
		"mist_raven":
			_use_current_mist_raven()
		"bloodletting_gourd":
			_use_current_bloodletting_gourd()


func _use_current_beast_whistle() -> void:
	if _owner_player == null:
		return
	var radius: float = 145.0 if ProstheticManager.is_upgrade_purchased("beast_whistle", "broad_resonance") else 110.0
	var reinforced: bool = ProstheticManager.is_upgrade_purchased("beast_whistle", "reinforced_resonance")
	var normal_posture: float = 24.0 if reinforced else 18.0
	var beast_posture: float = 38.0 if reinforced else 28.0
	var targets: Array[Node] = _targets_in_radius(_owner_player.global_position, radius)
	for target: Node in targets:
		var posture: float = beast_posture if _is_beast(target) else normal_posture
		_apply_canonical_contact(target, 0, posture, "beast_whistle")
		if not _is_control_protected(target):
			_interrupt_target(target, 0.35 if not _is_beast(target) else 0.55)
	_record("prosthetic_effect", {"prosthetic_id": "beast_whistle", "target_count": targets.size(), "radius": radius})


func _use_current_thunder_rod() -> void:
	if _owner_player == null:
		return
	var target: Node = _first_target_on_line(_owner_player.global_position, _activation_direction, 260.0, 18.0)
	if target == null:
		_record("prosthetic_effect", {"prosthetic_id": "thunder_rod", "target_count": 0})
		return
	var charged: bool = ProstheticManager.is_upgrade_purchased("thunder_rod", "charged_conductor")
	var health_damage: int = 28 if charged else 22
	var posture_damage: float = 24.0 if charged else 18.0
	var shock_duration: float = 5.0 if ProstheticManager.is_upgrade_purchased("thunder_rod", "lingering_current") else 3.0
	_apply_canonical_contact(target, health_damage, posture_damage, "thunder_rod")
	target.set_meta("_oathbound_shock_until", _now_s_current() + shock_duration)
	_record("prosthetic_shock_applied", {"target_id": target.get_instance_id(), "duration": shock_duration})


func _use_current_smoke_gourd() -> void:
	if _owner_player == null:
		return
	var radius: float = 155.0 if ProstheticManager.is_upgrade_purchased("smoke_gourd", "expanded_cloud") else 115.0
	var duration: float = 4.5 if ProstheticManager.is_upgrade_purchased("smoke_gourd", "dense_mixture") else 3.0
	_smoke_state = {
		"center": _owner_player.global_position,
		"radius": radius,
		"expires": _now_s_current() + duration,
		"inside_since": {},
	}
	_spawn_smoke_visual(Vector2(_smoke_state["center"]), radius, duration)
	_record("prosthetic_smoke_created", {"radius": radius, "duration": duration})


func _use_current_fang_harpoon() -> void:
	if _owner_player == null:
		return
	var target: Node = _first_target_on_line(_owner_player.global_position, _activation_direction, 220.0, 20.0)
	if target == null:
		_record("prosthetic_effect", {"prosthetic_id": "fang_harpoon", "target_count": 0})
		return
	var heavy_barb: bool = ProstheticManager.is_upgrade_purchased("fang_harpoon", "heavy_barb")
	var posture_damage: float = 28.0 if heavy_barb else 20.0
	var pull_distance: float = 65.0 if ProstheticManager.is_upgrade_purchased("fang_harpoon", "reinforced_chain") else 45.0
	_apply_canonical_contact(target, 10, posture_damage, "fang_harpoon")
	if not _is_control_protected(target):
		_pull_target(target, pull_distance)
		_interrupt_target(target, 0.34 if heavy_barb else 0.24)
	_record("prosthetic_effect", {"prosthetic_id": "fang_harpoon", "target_id": target.get_instance_id(), "pull_distance": pull_distance})


func _use_current_flame_vent() -> void:
	if _owner_player == null:
		return
	var reach: float = 130.0 if ProstheticManager.is_upgrade_purchased("flame_vent", "pressurized_vent") else 100.0
	var health_damage: int = 25 if ProstheticManager.is_upgrade_purchased("flame_vent", "refined_fuel") else 18
	var burn_duration: float = 6.0 if ProstheticManager.is_upgrade_purchased("flame_vent", "persistent_burn") else 4.0
	var targets: Array[Node] = _targets_in_cone(_owner_player.global_position, _activation_direction, reach, 70.0)
	for target: Node in targets:
		_apply_canonical_contact(target, health_damage, 8.0, "flame_vent")
		_apply_burn(target, burn_duration)
	_record("prosthetic_effect", {"prosthetic_id": "flame_vent", "target_count": targets.size(), "reach": reach, "burn_duration": burn_duration})


func _use_current_mist_raven() -> void:
	if _owner_player == null:
		return
	var distance: float = 92.0 if ProstheticManager.is_upgrade_purchased("mist_raven", "farther_passage") else 72.0
	var travel: Vector2 = _activation_direction.normalized() * distance
	var space_state: PhysicsDirectSpaceState2D = _owner_player.get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(_owner_player.global_position, _owner_player.global_position + travel, WORLD_MASK)
	query.exclude = [_owner_player.get_rid()]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result: Dictionary = space_state.intersect_ray(query)
	if not result.is_empty():
		var hit_position: Vector2 = Vector2(result.get("position", _owner_player.global_position))
		var safe_distance: float = maxf(0.0, _owner_player.global_position.distance_to(hit_position) - 6.0)
		travel = _activation_direction.normalized() * safe_distance
	_owner_player.is_invincible = true
	_owner_player.global_position += travel
	var player_ref: CharacterBody2D = _owner_player
	get_tree().create_timer(0.20).timeout.connect(func() -> void:
		if is_instance_valid(player_ref):
			player_ref.is_invincible = false
	)
	_record("prosthetic_mist_raven", {"requested_distance": distance, "actual_distance": travel.length()})


func _use_current_bloodletting_gourd() -> void:
	if _owner_player == null:
		return
	var heal_amount: int = 22 if ProstheticManager.is_upgrade_purchased("bloodletting_gourd", "deeper_draught") else 15
	var duration: float = 6.0 if ProstheticManager.is_upgrade_purchased("bloodletting_gourd", "longer_bloodletting") else 4.0
	var stronger_return: bool = ProstheticManager.is_upgrade_purchased("bloodletting_gourd", "stronger_return")
	var ratio: float = 0.18 if stronger_return else 0.12
	var cap: float = 18.0 if stronger_return else 12.0
	if "hp" in _owner_player and "maxhp" in _owner_player:
		_owner_player.hp = mini(int(_owner_player.maxhp), int(_owner_player.hp) + heal_amount)
		if _owner_player.has_method("_update_health_bar"):
			_owner_player.call("_update_health_bar")
	_owner_player.set_meta("_oathbound_bloodletting_until", _now_s_current() + duration)
	_owner_player.set_meta("_oathbound_bloodletting_ratio", ratio)
	_owner_player.set_meta("_oathbound_bloodletting_remaining", cap)
	_record("prosthetic_bloodletting", {"immediate_heal": heal_amount, "duration": duration, "ratio": ratio, "cap": cap})


func on_direct_sword_contact(target: Node, actual_health_damage: int, attack_area: Area2D = null) -> void:
	if target == null or not is_instance_valid(target):
		return
	var now: float = _now_s_current()
	var shock_until: float = float(target.get_meta("_oathbound_shock_until", 0.0))
	if shock_until > now:
		target.remove_meta("_oathbound_shock_until")
		var combat_node: Node = target.get_node_or_null("Combat")
		if combat_node != null and combat_node.has_method("add_posture"):
			combat_node.call("add_posture", 12.0)
		_record("prosthetic_shock_consumed", {"target_id": target.get_instance_id(), "bonus_posture": 12.0})
	elif target.has_meta("_oathbound_shock_until"):
		target.remove_meta("_oathbound_shock_until")

	if _owner_player == null or actual_health_damage <= 0:
		return
	var lifesteal_until: float = float(_owner_player.get_meta("_oathbound_bloodletting_until", 0.0))
	if lifesteal_until <= now:
		return
	var remaining: float = float(_owner_player.get_meta("_oathbound_bloodletting_remaining", 0.0))
	if remaining <= 0.0:
		return
	var ratio: float = float(_owner_player.get_meta("_oathbound_bloodletting_ratio", 0.12))
	var heal_float: float = minf(remaining, float(actual_health_damage) * ratio)
	if heal_float <= 0.0:
		return
	var heal_amount: int = maxi(1, int(floor(heal_float)))
	heal_amount = mini(heal_amount, int(ceil(remaining)))
	_owner_player.set_meta("_oathbound_bloodletting_remaining", maxf(0.0, remaining - float(heal_amount)))
	if "hp" in _owner_player and "maxhp" in _owner_player:
		var hp_before: int = int(_owner_player.hp)
		_owner_player.hp = mini(int(_owner_player.maxhp), hp_before + heal_amount)
		var actual_heal: int = int(_owner_player.hp) - hp_before
		if actual_heal > 0 and _owner_player.has_method("_update_health_bar"):
			_owner_player.call("_update_health_bar")
		_record("prosthetic_bloodletting_heal", {"actual_sword_damage": actual_health_damage, "heal": actual_heal})


func _apply_burn(target: Node, duration: float) -> void:
	var id: int = target.get_instance_id()
	_burn_states[id] = {
		"target": weakref(target),
		"expires": _now_s_current() + duration,
		"next_tick": _now_s_current() + 1.0,
	}
	target.set_meta("_oathbound_burn_until", _now_s_current() + duration)
	_record("prosthetic_burn_applied", {"target_id": id, "duration": duration, "dps": 3})


func _tick_burn(_delta: float) -> void:
	if _burn_states.is_empty():
		return
	var now: float = _now_s_current()
	for id_value: Variant in _burn_states.keys().duplicate():
		var id: int = int(id_value)
		var state: Dictionary = _burn_states[id]
		var target_ref: WeakRef = state.get("target", null)
		var target: Node = target_ref.get_ref() if target_ref != null else null
		if target == null or not is_instance_valid(target) or now >= float(state.get("expires", 0.0)):
			_burn_states.erase(id)
			continue
		if now >= float(state.get("next_tick", 0.0)):
			_apply_canonical_contact(target, 3, 0.0, "flame_vent_burn")
			state["next_tick"] = float(state.get("next_tick", now)) + 1.0
			_burn_states[id] = state


func _tick_smoke() -> void:
	if _smoke_state.is_empty():
		return
	var now: float = _now_s_current()
	var expires: float = float(_smoke_state.get("expires", 0.0))
	if now >= expires:
		_smoke_state.clear()
		return
	var center: Vector2 = Vector2(_smoke_state.get("center", Vector2.ZERO))
	var radius: float = float(_smoke_state.get("radius", 115.0))
	var inside_since: Dictionary = _smoke_state.get("inside_since", {})
	var currently_inside: Dictionary = {}
	for target: Node in _all_enemy_targets():
		if not (target is Node2D):
			continue
		if _is_control_protected(target):
			continue
		var dist: float = center.distance_to((target as Node2D).global_position)
		if dist > radius:
			continue
		var id: int = target.get_instance_id()
		currently_inside[id] = true
		if not inside_since.has(id):
			inside_since[id] = now
		if now - float(inside_since[id]) >= 0.25:
			target.set_meta("_oathbound_smoke_disrupted_until", now + 0.15)
			target.set_meta("_oathbound_smoke_attack_distance", SMOKE_ATTACK_DISTANCE)
	for id_value: Variant in inside_since.keys().duplicate():
		if not currently_inside.has(int(id_value)):
			inside_since.erase(id_value)
	_smoke_state["inside_since"] = inside_since


func _spawn_smoke_visual(center: Vector2, radius: float, duration: float) -> void:
	var cloud := Node2D.new()
	cloud.global_position = center
	var polygon := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(24):
		var angle: float = TAU * float(index) / 24.0
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	polygon.polygon = points
	polygon.color = Color(0.58, 0.60, 0.62, 0.28)
	cloud.add_child(polygon)
	get_tree().current_scene.add_child(cloud)
	get_tree().create_timer(duration).timeout.connect(func() -> void:
		if is_instance_valid(cloud):
			cloud.queue_free()
	)


func _apply_canonical_contact(target: Node, health_damage: int, posture_damage: float, attack_id: String) -> void:
	if target == null or not is_instance_valid(target) or not target.has_method("_on_hurt_box_hurt"):
		return
	var carrier := Area2D.new()
	carrier.add_to_group("attack")
	carrier.monitoring = false
	carrier.monitorable = false
	carrier.global_position = _owner_player.global_position if _owner_player != null else Vector2.ZERO
	carrier.set_meta("attacker", _owner_player)
	carrier.set_meta("health_damage", health_damage)
	carrier.set_meta("posture_damage", posture_damage)
	carrier.set_meta("block_posture_damage", posture_damage)
	carrier.set_meta("stagger_level", 0)
	carrier.set_meta("proc_coefficient", 0.0)
	carrier.set_meta("attack_id", attack_id)
	carrier.set_meta("damage_type", "oathbound_prosthetic")
	carrier.set_meta("oathbound_prosthetic", true)
	get_tree().current_scene.add_child(carrier)

	var combat_node: Node = target.get_node_or_null("Combat")
	var posture_before: float = 0.0
	if combat_node != null and combat_node.has_method("get_posture"):
		posture_before = float(combat_node.call("get_posture"))
	var event: Dictionary = {
		"health_damage": health_damage,
		"posture_damage": posture_damage,
		"block_posture_damage": posture_damage,
		"stagger_level": 0,
		"proc_coefficient": 0.0,
		"attack_id": attack_id,
		"source": _owner_player,
	}
	if combat_node != null and combat_node.has_method("begin_attack_event"):
		combat_node.call("begin_attack_event", event)
	target.call("_on_hurt_box_hurt", health_damage, "oathbound_attack", carrier)
	if combat_node != null and combat_node.has_method("end_attack_event"):
		combat_node.call("end_attack_event")

	if posture_damage > 0.0 and combat_node != null and combat_node.has_method("get_posture") and combat_node.has_method("add_posture"):
		var posture_after: float = float(combat_node.call("get_posture"))
		if posture_after <= posture_before + 0.001:
			combat_node.call("add_posture", posture_damage)
	_record("prosthetic_contact", {
		"prosthetic_attack_id": attack_id,
		"target_id": target.get_instance_id(),
		"health_damage": health_damage,
		"posture_damage": posture_damage,
	})
	carrier.call_deferred("queue_free")


func _interrupt_target(target: Node, duration: float) -> void:
	if target == null or not is_instance_valid(target) or _is_control_protected(target):
		return
	if typeof(AttackDir) == TYPE_OBJECT and AttackDir.has_method("release_all_for"):
		AttackDir.release_all_for(target)
	if typeof(ProstheticEffects) == TYPE_OBJECT:
		if ProstheticEffects.has_method("_stun"):
			ProstheticEffects.call("_stun", target, duration)
		elif ProstheticEffects.has_method("_cancel_attack"):
			ProstheticEffects.call("_cancel_attack", target)
	target.set_meta("_oathbound_prosthetic_interrupt_until", _now_s_current() + duration)


func _pull_target(target: Node, distance: float) -> void:
	if _owner_player == null or not (target is CharacterBody2D):
		return
	var body := target as CharacterBody2D
	var direction: Vector2 = (_owner_player.global_position - body.global_position).normalized()
	body.move_and_collide(direction * distance)


func _targets_in_radius(center: Vector2, radius: float) -> Array[Node]:
	var result: Array[Node] = []
	for target: Node in _all_enemy_targets():
		if target is Node2D and center.distance_to((target as Node2D).global_position) <= radius:
			result.append(target)
	return result


func _targets_in_cone(center: Vector2, direction: Vector2, reach: float, angle_degrees: float) -> Array[Node]:
	var result: Array[Node] = []
	var dir: Vector2 = direction.normalized()
	if dir.length() < 0.01:
		dir = Vector2.RIGHT
	var half_angle: float = angle_degrees * 0.5
	for target: Node in _all_enemy_targets():
		if not (target is Node2D):
			continue
		var offset: Vector2 = (target as Node2D).global_position - center
		if offset.length() > reach or offset.length() < 0.001:
			continue
		var target_angle: float = absf(rad_to_deg(dir.angle_to(offset.normalized())))
		if target_angle <= half_angle:
			result.append(target)
	return result


func _first_target_on_line(center: Vector2, direction: Vector2, range_px: float, half_width: float) -> Node:
	var best_target: Node = null
	var best_forward: float = range_px + 1.0
	var dir: Vector2 = direction.normalized()
	for target: Node in _all_enemy_targets():
		if not (target is Node2D):
			continue
		var offset: Vector2 = (target as Node2D).global_position - center
		var forward: float = offset.dot(dir)
		if forward < 0.0 or forward > range_px:
			continue
		var lateral: float = absf(offset.cross(dir))
		if lateral <= half_width and forward < best_forward:
			best_forward = forward
			best_target = target
	return best_target


func _all_enemy_targets() -> Array[Node]:
	var result: Array[Node] = []
	var seen: Dictionary = {}
	for group_name: String in ["enemy", "miniboss"]:
		for target: Node in get_tree().get_nodes_in_group(group_name):
			if target == null or not is_instance_valid(target):
				continue
			var id: int = target.get_instance_id()
			if seen.has(id):
				continue
			seen[id] = true
			result.append(target)
	return result


func _is_beast(target: Node) -> bool:
	if target == null:
		return false
	if target.is_in_group("beast"):
		return true
	if target.has_method("get_enemy_tags"):
		var tags_value: Variant = target.call("get_enemy_tags")
		if tags_value is Array and (tags_value as Array).has("beast"):
			return true
	var enemy_type: String = str(target.get_meta("hushiro_enemy_type", ""))
	return enemy_type in ["hound", "hollow"]


func _is_control_protected(target: Node) -> bool:
	if target == null:
		return true
	if target.is_in_group("boss") or target.is_in_group("miniboss"):
		return true
	if bool(target.get_meta("control_protected", false)):
		return true
	return str(target.get_meta("hushiro_enemy_type", "")) == "warden"


func _get_current_aim_direction() -> Vector2:
	if _owner_player == null:
		return Vector2.RIGHT
	var delta: Vector2 = _owner_player.get_global_mouse_position() - _owner_player.global_position
	if delta.length() >= 6.0:
		return delta.normalized()
	var facing_value: Variant = _owner_player.get("_facing_dir")
	if facing_value is Vector2 and (facing_value as Vector2).length() > 0.01:
		return (facing_value as Vector2).normalized()
	return Vector2.RIGHT


func _effective_spirit_cost(prosthetic_id: String) -> int:
	if ProstheticManager.has_method("get_effective_spirit_cost"):
		return int(ProstheticManager.get_effective_spirit_cost(prosthetic_id))
	var data: ProstheticData = ProstheticManager.get_prosthetic(prosthetic_id)
	return maxi(0, data.spirit_cost) if data != null else 0


func add_spirit(amount: int) -> void:
	if amount <= 0:
		return
	current_spirit = mini(max_spirit, current_spirit + amount)
	spirit_changed.emit(current_spirit, max_spirit)


func get_spirit() -> int:
	return current_spirit


func get_max_spirit() -> int:
	return max_spirit


func get_cooldown_pct() -> float:
	if _cooldown_total <= 0.0 or _cooldown_timer <= 0.0:
		return 0.0
	return clampf(_cooldown_timer / _cooldown_total, 0.0, 1.0)


func is_using() -> bool:
	return not _active_prosthetic_id.is_empty()


func get_equipped_info() -> Dictionary:
	var prosthetic_id: String = str(ProstheticManager.equipped_prosthetic_id)
	return {
		"id": prosthetic_id,
		"spirit_cost": _effective_spirit_cost(prosthetic_id),
		"sockets": 0,
		"filled": 0,
	}


func get_runtime_contract() -> Dictionary:
	return {
		"version": CURRENT_RUNTIME_VERSION,
		"script": get_script().resource_path if get_script() is Script else "",
		"spirit_max": max_spirit,
		"equipped": str(ProstheticManager.equipped_prosthetic_id),
	}


func _now_s_current() -> float:
	return Time.get_ticks_msec() * 0.001


func _record(event_name: String, payload: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event(event_name, payload)
