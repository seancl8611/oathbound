extends "res://Player/OathboundAspectPlayerRuntime.gd"

## Final current Player integration layer.
## Owns current defensive aim/deathblow compatibility, canonical Prosthetic execution,
## Player-side Relic hooks, and Corruption combat/lifecycle credit.

const DEFENSIVE_AIM_MIN_DISTANCE: float = 6.0
const CURRENT_PROSTHETIC_EXECUTOR_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundProstheticExecutor.gd")
const EXPECTED_PROSTHETIC_EXECUTOR_SCRIPT: String = "res://Core/Prosthetics/OathboundProstheticExecutor.gd"
const CURRENT_RUN_HUD_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundRunHUD.gd")
const EXPECTED_RUN_HUD_SCRIPT: String = "res://Core/Prosthetics/OathboundRunHUD.gd"
const EXPECTED_CORRUPTION_RUNTIME_SCRIPT: String = "res://Core/Corruption/OathboundCorruptionRuntime.gd"
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")


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
	_connect_relic_runtime()
	_refresh_relic_capacity(true)
	_capture_run_start_capacity()
	_assert_relic_runtime()
	_assert_corruption_runtime()
	print("[OathboundCombatPlayer] v1.5 - canonical Aspect Player + defense/deathblow/Prosthetic/Relic/Corruption bridge")


func _install_current_run_hud() -> void:
	# LegacyPlayerController creates and initializes the imported RunHUD during
	# super._ready(). Replacing that node's script afterwards clears the script-owned
	# UI references, so replace the whole HUD with a freshly initialized current HUD.
	var old_hud: Node = run_hud
	var hud_value: Variant = CURRENT_RUN_HUD_SCRIPT.new()
	if not (hud_value is CanvasLayer):
		push_error("[OathboundCombatPlayer] Could not instantiate current RunHUD")
		return

	if old_hud != null and is_instance_valid(old_hud):
		if old_hud.get_parent() != null:
			old_hud.get_parent().remove_child(old_hud)
		old_hud.free()

	run_hud = hud_value as CanvasLayer
	run_hud.name = "RunHUD"
	add_child(run_hud)
	if run_hud.has_method("setup"):
		run_hud.call("setup", self)

	var hud_script_path: String = ""
	var hud_script_value: Variant = run_hud.get_script()
	if hud_script_value is Script:
		hud_script_path = (hud_script_value as Script).resource_path
	print("[OathboundCombatPlayer] run_hud script=%s" % hud_script_path)
	if hud_script_path != EXPECTED_RUN_HUD_SCRIPT:
		push_error("[OathboundCombatPlayer] Wrong RunHUD script: %s" % hud_script_path)

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


# =============================================================================
# RELIC CAPACITY / LIVE EQUIP
# =============================================================================

func _connect_relic_runtime() -> void:
	var runtime: Node = _relic_runtime()
	if runtime == null:
		return
	var equip_cb := Callable(self, "_on_relic_equipped_changed")
	if runtime.has_signal("equipped_changed") and not runtime.is_connected("equipped_changed", equip_cb):
		runtime.connect("equipped_changed", equip_cb)
	var mastery_cb := Callable(self, "_on_relic_mastery_changed")
	if runtime.has_signal("mastery_changed") and not runtime.is_connected("mastery_changed", mastery_cb):
		runtime.connect("mastery_changed", mastery_cb)


func _on_relic_equipped_changed(_relic_id: String) -> void:
	_refresh_relic_capacity(false)


func _on_relic_mastery_changed(relic_id: String, _kills: int, _rank: int) -> void:
	var runtime: Node = _relic_runtime()
	if runtime != null and str(runtime.get("equipped_relic_id")) == relic_id:
		_refresh_relic_capacity(false)


func _refresh_relic_capacity(fill_added_capacity: bool) -> void:
	var runtime: Node = _relic_runtime()
	if runtime == null:
		return
	var equipped: String = str(runtime.get("equipped_relic_id"))

	# Health: subtract only the previously applied Relic bonus, preserving permanent
	# progression and temporary Shop capacity, then add the new Relic bonus.
	var old_hp_bonus: int = int(get_meta("_oathbound_relic_health_bonus", 0))
	var new_hp_bonus: int = 0
	if equipped == RELIC_CATALOG.IRON_PRAYER_BEAD:
		new_hp_bonus = maxi(0, int(round(float(runtime.call("get_effective_value", equipped)))))
	var non_relic_hp_max: int = maxi(1, int(maxhp) - old_hp_bonus)
	var new_hp_max: int = non_relic_hp_max + new_hp_bonus
	var hp_bonus_delta: int = new_hp_bonus - old_hp_bonus
	maxhp = new_hp_max
	if fill_added_capacity and hp_bonus_delta > 0:
		hp = mini(maxhp, int(hp) + hp_bonus_delta)
	else:
		hp = mini(int(hp), maxhp)
	set_meta("_oathbound_relic_health_bonus", new_hp_bonus)
	_update_health_bar()

	# Spirit follows the same isolated-bonus rule through the canonical executor.
	if prosthetic_executor != null:
		var old_spirit_bonus: int = int(prosthetic_executor.get_meta("_oathbound_relic_spirit_bonus", 0))
		var new_spirit_bonus: int = 0
		if equipped == RELIC_CATALOG.SPIRIT_TASSEL:
			new_spirit_bonus = maxi(0, int(round(float(runtime.call("get_effective_value", equipped)))))
		var current_max: int = int(prosthetic_executor.call("get_max_spirit")) if prosthetic_executor.has_method("get_max_spirit") else 100
		var current_spirit: int = int(prosthetic_executor.call("get_spirit")) if prosthetic_executor.has_method("get_spirit") else current_max
		var non_relic_spirit_max: int = maxi(1, current_max - old_spirit_bonus)
		var new_spirit_max: int = non_relic_spirit_max + new_spirit_bonus
		var spirit_bonus_delta: int = new_spirit_bonus - old_spirit_bonus
		var new_current_spirit: int = mini(current_spirit, new_spirit_max)
		if fill_added_capacity and spirit_bonus_delta > 0:
			new_current_spirit = mini(new_spirit_max, current_spirit + spirit_bonus_delta)
		prosthetic_executor.set("max_spirit", new_spirit_max)
		prosthetic_executor.set("current_spirit", new_current_spirit)
		prosthetic_executor.set_meta("_oathbound_relic_spirit_bonus", new_spirit_bonus)
		if prosthetic_executor.has_signal("spirit_changed"):
			prosthetic_executor.emit_signal("spirit_changed", new_current_spirit, new_spirit_max)
		if run_hud != null and run_hud.has_method("update_spirit"):
			run_hud.call("update_spirit", new_current_spirit, new_spirit_max)


func _capture_run_start_capacity() -> void:
	# Current Shop temporary-capacity purchases are percentages of the run-start max.
	# Capture after pre-run Relic capacity has been applied, before any Shop purchase.
	if not has_meta("_oathbound_run_start_max_health"):
		set_meta("_oathbound_run_start_max_health", int(maxhp))
	if prosthetic_executor != null and not prosthetic_executor.has_meta("_oathbound_run_start_max_spirit"):
		var current_max: int = int(prosthetic_executor.call("get_max_spirit")) if prosthetic_executor.has_method("get_max_spirit") else 100
		prosthetic_executor.set_meta("_oathbound_run_start_max_spirit", current_max)


func _assert_relic_runtime() -> void:
	var runtime: Node = _relic_runtime()
	if runtime == null:
		push_error("[OathboundCombatPlayer] RelicRuntime missing")
		return
	var script_path: String = ""
	var script_value: Variant = runtime.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	var equipped: String = str(runtime.get("equipped_relic_id"))
	print("[OathboundCombatPlayer] relic_runtime script=%s equipped=%s" % [script_path, equipped if not equipped.is_empty() else "none"])
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("relic_runtime_assigned", {
			"script": script_path,
			"equipped": equipped,
		})


func _assert_corruption_runtime() -> void:
	var runtime: Node = _corruption_runtime()
	if runtime == null:
		push_error("[OathboundCombatPlayer] CorruptionRuntime missing")
		return
	var script_path: String = ""
	var script_value: Variant = runtime.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	print("[OathboundCombatPlayer] corruption_runtime script=%s awakened=%s" % [script_path, str(runtime.call("is_awakened"))])
	if script_path != EXPECTED_CORRUPTION_RUNTIME_SCRIPT:
		push_error("[OathboundCombatPlayer] Wrong CorruptionRuntime script: %s" % script_path)


# =============================================================================
# RELIC / CORRUPTION COMBAT EVENTS
# =============================================================================

func take_damage(amount: int, show_feedback: bool = true) -> void:
	var hp_before: int = int(hp)
	var actual_damage: int = maxi(0, amount - int(armor))
	var relic_runtime: Node = _relic_runtime()
	if relic_runtime != null and relic_runtime.has_method("try_last_oath"):
		var survivor_hp: int = int(relic_runtime.call("try_last_oath", hp_before, actual_damage))
		if survivor_hp >= 0:
			hp = mini(int(maxhp), survivor_hp)
			if actual_damage > 0 and relic_runtime.has_method("on_player_health_damage"):
				relic_runtime.call("on_player_health_damage", actual_damage)
			if show_feedback:
				_flash_player(Color(1, 0.3, 0.3), 0.12)
				_shake_camera(SHAKE_MEDIUM, 0.12)
			_update_health_bar()
			return

	# Last Oath has already had the chance to convert lethal damage. Only a genuinely
	# lethal hit reaches the Corruption death/awakening transition.
	if hp_before > 0 and actual_damage >= hp_before:
		var corruption_runtime: Node = _corruption_runtime()
		if corruption_runtime != null and corruption_runtime.has_method("on_player_death"):
			corruption_runtime.call("on_player_death")

	super.take_damage(amount, show_feedback)
	var hp_lost: int = maxi(0, hp_before - int(hp))
	if hp_lost > 0 and relic_runtime != null and relic_runtime.has_method("on_player_health_damage"):
		relic_runtime.call("on_player_health_damage", hp_lost)


func _try_deathblow() -> bool:
	var target: Node = _get_deathblow_target()
	var started: bool = super._try_deathblow()
	if started:
		var corruption_runtime: Node = _corruption_runtime()
		if corruption_runtime != null and corruption_runtime.has_method("on_deathblow"):
			corruption_runtime.call("on_deathblow", target)
		var relic_runtime: Node = _relic_runtime()
		if relic_runtime != null and relic_runtime.has_method("on_deathblow"):
			relic_runtime.call("on_deathblow", self)
	return started


func _handle_parry_success(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2, is_perfect: bool) -> void:
	super._handle_parry_success(area, attacker, dmg_type, atk_pos, is_perfect)
	var runtime: Node = _corruption_runtime()
	if runtime != null and runtime.has_method("on_successful_parry"):
		runtime.call("on_successful_parry")


func _handle_grace_parry(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2) -> void:
	super._handle_grace_parry(area, attacker, dmg_type, atk_pos)
	var runtime: Node = _corruption_runtime()
	if runtime != null and runtime.has_method("on_successful_parry"):
		runtime.call("on_successful_parry")


func _try_activate_blood_art() -> void:
	var was_resolving: bool = bool(AspectRuntime.blood_art_resolving) if typeof(AspectRuntime) == TYPE_OBJECT else false
	super._try_activate_blood_art()
	var now_resolving: bool = bool(AspectRuntime.blood_art_resolving) if typeof(AspectRuntime) == TYPE_OBJECT else false
	if not was_resolving and now_resolving:
		var runtime: Node = _relic_runtime()
		if runtime != null and runtime.has_method("on_blood_art_used"):
			runtime.call("on_blood_art_used", self)


# =============================================================================
# CURRENT DEFENSE / PROSTHETIC BRIDGES
# =============================================================================

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


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")


func _corruption_runtime() -> Node:
	return get_node_or_null("/root/CorruptionRuntime")
