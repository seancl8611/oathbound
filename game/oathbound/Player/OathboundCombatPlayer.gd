extends "res://Player/OathboundAspectPlayerRuntime.gd"

## Final current Player integration layer for the combat-contract stabilization pass.
## Defensive facing follows the same mouse/world aim language as sword attacks instead
## of preserving the last movement vector while Akio stands still and blocks.
## Hushiro's explicit posture-break runtime marker is also accepted as a Deathblow
## target so imported family-specific readiness methods cannot hide a valid break.
## This layer also installs the current Prosthetic executor before the inherited Player
## child nodes reach _ready(), keeping legacy scene structure while giving the live run
## one explicit Prosthetic combat authority.

const DEFENSIVE_AIM_MIN_DISTANCE: float = 6.0
const CURRENT_PROSTHETIC_EXECUTOR_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundProstheticExecutor.gd")
const EXPECTED_PROSTHETIC_EXECUTOR_SCRIPT: String = "res://Core/Prosthetics/OathboundProstheticExecutor.gd"
const CURRENT_RUN_HUD_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundRunHUD.gd")


func _enter_tree() -> void:
	var executor_node: Node = get_node_or_null("ProstheticExecutor")
	if executor_node == null:
		push_error("[OathboundCombatPlayer] ProstheticExecutor child missing before ready")
		return
	executor_node.set_script(CURRENT_PROSTHETIC_EXECUTOR_SCRIPT)


func _ready() -> void:
	super._ready()
	_install_current_run_hud()
	_assert_prosthetic_runtime()
	print("[OathboundCombatPlayer] v1.2 - canonical Aspect Player + defense/deathblow/Prosthetic bridge")


func _install_current_run_hud() -> void:
	if run_hud == null:
		return
	run_hud.set_script(CURRENT_RUN_HUD_SCRIPT)
	if prosthetic_executor != null and run_hud.has_method("update_spirit"):
		var spirit: int = int(prosthetic_executor.call("get_spirit")) if prosthetic_executor.has_method("get_spirit") else 100
		var spirit_max: int = int(prosthetic_executor.call("get_max_spirit")) if prosthetic_executor.has_method("get_max_spirit") else 100
		run_hud.call("update_spirit", spirit, spirit_max)
	if prosthetic_executor != null and prosthetic_executor.has_method("get_equipped_info") and run_hud.has_method("update_prosthetic_info"):
		var info: Dictionary = prosthetic_executor.call("get_equipped_info")
		run_hud.call("update_prosthetic_info", str(info.get("id", "")), int(info.get("spirit_cost", 0)), 0, 0)


func _assert_prosthetic_runtime() -> void:
	if prosthetic_executor == null:
		push_error("[OathboundCombatPlayer] Current Prosthetic executor missing")
		return
	var script_path: String = ""
	var script_value: Variant = prosthetic_executor.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	print("[OathboundCombatPlayer] prosthetic_executor script=%s" % script_path)
	if script_path != EXPECTED_PROSTHETIC_EXECUTOR_SCRIPT:
		push_error("[OathboundCombatPlayer] Wrong Prosthetic executor script: %s" % script_path)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("prosthetic_executor_assigned", {
			"script": script_path,
			"expected": EXPECTED_PROSTHETIC_EXECUTOR_SCRIPT,
			"matches_expected": script_path == EXPECTED_PROSTHETIC_EXECUTOR_SCRIPT,
		})


func _start_parry(window_s: float) -> void:
	_update_defensive_facing()
	super._start_parry(window_s)
	_record_guard_aim("parry_open")


func _state_parrying(delta: float) -> void:
	if Input.is_action_pressed("parry"):
		_update_defensive_facing()
	super._state_parrying(delta)


func _state_blocking(delta: float) -> void:
	_update_defensive_facing()
	super._state_blocking(delta)


func _on_attack_hit(target: Node, combo_idx: int) -> void:
	var was_blocked: bool = false
	if target != null and target.has_method("is_blocking"):
		was_blocked = bool(target.call("is_blocking"))
	super._on_attack_hit(target, combo_idx)
	if prosthetic_executor == null or not prosthetic_executor.has_method("on_direct_sword_contact"):
		return
	var actual_health_damage: int = 0
	if not was_blocked and sword_hitbox != null and sword_hitbox.has_method("get_current_damage"):
		actual_health_damage = int(sword_hitbox.call("get_current_damage"))
	prosthetic_executor.call("on_direct_sword_contact", target, actual_health_damage, sword_hitbox)


func _on_hurt(dmg: int, dmg_type: String, attacker: Node = null) -> void:
	if prosthetic_executor != null and prosthetic_executor.has_method("try_umbrella_absorb"):
		if bool(prosthetic_executor.call("try_umbrella_absorb", dmg, dmg_type, attacker)):
			apply_hitstop(HITSTOP_BLOCKED)
			_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
			_flash_player(Color(0.55, 0.72, 1.0), 0.08)
			return
	super._on_hurt(dmg, dmg_type, attacker)


func get_defensive_facing() -> Vector2:
	return _facing_dir.normalized() if _facing_dir.length() > 0.01 else Vector2.RIGHT


func apply_umbrella_posture(amount: float) -> void:
	if amount <= 0.0:
		return
	var now: float = Time.get_ticks_msec() * 0.001
	stagger = clampf(stagger + amount, 0.0, stagger_max)
	_stagger_suppress_until = now + 0.4
	_update_stagger_ui()
	if stagger >= stagger_max - 0.001:
		_posture_break()


func _get_deathblow_target() -> Node:
	var inherited_target: Node = super._get_deathblow_target()
	if inherited_target != null:
		return inherited_target

	var best_target: Node = null
	var best_distance: float = FINISHER_RADIUS
	for group_name: String in ["enemy", "miniboss"]:
		for candidate: Node in get_tree().get_nodes_in_group(group_name):
			if candidate == null or not is_instance_valid(candidate):
				continue
			if not bool(candidate.get_meta("_oathbound_deathblow_ready", false)):
				continue
			if not (candidate is Node2D):
				continue
			var distance: float = global_position.distance_to((candidate as Node2D).global_position)
			if distance <= best_distance:
				best_distance = distance
				best_target = candidate

	if best_target != null and typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_deathblow_marker_target", {
			"enemy": CombatTelemetry.snapshot_actor(best_target),
			"distance": best_distance,
		})
	return best_target


func _update_defensive_facing() -> void:
	var aim_delta: Vector2 = get_global_mouse_position() - global_position
	if aim_delta.length() < DEFENSIVE_AIM_MIN_DISTANCE:
		return
	var aim_dir: Vector2 = aim_delta.normalized()
	_facing_dir = aim_dir
	_attack_aim_dir = aim_dir
	_update_sprite_facing(aim_dir)


func _record_guard_aim(source: String) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event("player_guard_aim", {
		"source": source,
		"facing": [_facing_dir.x, _facing_dir.y],
		"mouse_world": [get_global_mouse_position().x, get_global_mouse_position().y],
		"player": CombatTelemetry.snapshot_actor(self),
	})
