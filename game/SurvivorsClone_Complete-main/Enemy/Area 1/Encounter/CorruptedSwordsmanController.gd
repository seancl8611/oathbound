extends "res://Enemy/Area 1/Encounter/corrupted_swordsman.gd"

## =============================================================================
## CORRUPTED SWORDSMAN - CURRENT HUSHIRO RULES LAYER
## =============================================================================
## The imported swordsman controller still owns its animation/HFSM plumbing while
## Area 1 is reconciled. This script is the current Hushiro behavior authority for
## rules that have already been approved and playtested:
## - guard must be an explicit defend state, not permanent frontal invulnerability;
## - Quick Thrust is perilous: no block, yes parry/dash;
## - perilous-thrust parries apply 1.5x normal parry posture pressure;
## - ordinary posture break exposes a 2.5 second Deathblow window;
## - enemy -> Player contacts are emitted into structured playtest telemetry.
##
## This is intentionally a temporary inheritance bridge, not a second Swordsman
## implementation. Once the imported HFSM/animation plumbing has been replaced,
## corrupted_swordsman.gd can be retired and this controller can stand alone.
## =============================================================================

const HUSHIRO_DEATHBLOW_WINDOW: float = 2.5
const HUSHIRO_NORMAL_PARRY_POSTURE: float = 25.0
const HUSHIRO_PERILOUS_THRUST_PARRY_MULT: float = 1.5
const HUSHIRO_BLOCK_POSTURE_DAMAGE: float = 12.0

@export_group("Hushiro Guard")
@export var hushiro_guard_range: float = 95.0

func _update_blocking(_delta: float, now: float) -> void:
	if not can_block or _dbroken_active:
		_set_blocking(false)
		return
	if telegraphing or (is_attacking and not _attack_recovery):
		_set_blocking(false)
		return
	if ProstheticEffects.is_confused(self):
		_set_blocking(false)
		return
	if now < _block_stagger_until:
		_set_blocking(false)
		return
	if not is_instance_valid(player):
		_set_blocking(false)
		return
	if ai_state != AIState.DEFEND:
		_set_blocking(false)
		return
	var distance_to_player: float = global_position.distance_to(player.global_position)
	_set_blocking(distance_to_player <= minf(hushiro_guard_range, deaggro_radius))

func _is_frontal_attack(attacker: Variant) -> bool:
	if not _block_active:
		return false
	return super._is_frontal_attack(attacker)

func _on_base_posture_meter_filled() -> void:
	if not _dbroken_active:
		_trigger_posture_break(HUSHIRO_DEATHBLOW_WINDOW)

func receive_deathblow(attacker: Node) -> void:
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_deathblow_executed", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"attacker": CombatTelemetry.snapshot_actor(attacker) if attacker != null else {},
		})
	super.receive_deathblow(attacker)

func on_parried(player_pos: Vector2) -> void:
	var was_perilous_thrust: bool = _current_attack_type == AttackType.QUICK_THRUST
	# The inherited controller applies the shared normal 25-point response before its
	# recoil await. Preserve that async flow and add only the perilous-thrust bonus.
	super.on_parried(player_pos)
	if was_perilous_thrust:
		var bonus_posture: float = HUSHIRO_NORMAL_PARRY_POSTURE * (HUSHIRO_PERILOUS_THRUST_PARRY_MULT - 1.0)
		add_posture_damage(bonus_posture)
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("perilous_thrust_parry_bonus", {
				"enemy": CombatTelemetry.snapshot_actor(self),
				"bonus_posture": bonus_posture,
				"target_total_pressure": HUSHIRO_NORMAL_PARRY_POSTURE * HUSHIRO_PERILOUS_THRUST_PARRY_MULT,
			})

func _on_swipe_area_entered(player_hurtbox: Area2D) -> void:
	if player_hurtbox == null or not player_hurtbox.is_in_group("player_hurtbox"):
		return
	if not _consume_current_attack_contact():
		return
	var damage: int = swipe_damage
	if is_instance_valid(_current_swipe_area) and _current_swipe_area.has_meta("damage"):
		damage = int(_current_swipe_area.get_meta("damage"))
	_stamp_current_attack_event(damage, "melee", true)
	_emit_player_hurt_and_record(player_hurtbox, damage, "melee")

func _on_thrust_area_entered(player_hurtbox: Area2D) -> void:
	if player_hurtbox == null or not player_hurtbox.is_in_group("player_hurtbox"):
		return
	if not _consume_current_attack_contact():
		return
	_thrust_hit_player = true
	var damage: int = thrust_damage
	if is_instance_valid(_current_swipe_area) and _current_swipe_area.has_meta("damage"):
		damage = int(_current_swipe_area.get_meta("damage"))
	_stamp_current_attack_event(damage, "perilous", false)
	_emit_player_hurt_and_record(player_hurtbox, damage, "perilous")

func _consume_current_attack_contact() -> bool:
	if not is_instance_valid(_current_swipe_area):
		return false
	if _current_swipe_area.has_meta("consumed") and bool(_current_swipe_area.get_meta("consumed")):
		return false
	_current_swipe_area.set_meta("consumed", true)
	return true

func _stamp_current_attack_event(damage: int, damage_type: String, blockable: bool) -> void:
	if not is_instance_valid(_current_swipe_area):
		return
	_current_swipe_area.set_meta("attack_id", _current_hushiro_attack_id())
	_current_swipe_area.set_meta("health_damage", damage)
	_current_swipe_area.set_meta("posture_damage", 0.0)
	_current_swipe_area.set_meta("block_posture_damage", HUSHIRO_BLOCK_POSTURE_DAMAGE)
	_current_swipe_area.set_meta("damage_type", damage_type)
	_current_swipe_area.set_meta("parryable", true)
	_current_swipe_area.set_meta("blockable", blockable)
	_current_swipe_area.set_meta("perilous", damage_type == "perilous")
	_current_swipe_area.set_meta("proc_coefficient", 1.0)

func _current_hushiro_attack_id() -> String:
	match _current_attack_type:
		AttackType.BASIC_SWING:
			return "basic_swing"
		AttackType.QUICK_THRUST:
			return "quick_thrust"
		AttackType.CROSS_SWING:
			return "cross_swing"
		AttackType.RUNNING_SWING:
			return "running_swing"
		_:
			return "swordsman_attack"

func _emit_player_hurt_and_record(player_hurtbox: Area2D, damage: int, damage_type: String) -> void:
	var receiver: Node = player_hurtbox.get_parent()
	var before: Dictionary = {}
	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null:
		before = CombatTelemetry.snapshot_actor(receiver)
	player_hurtbox.emit_signal("hurt", damage, damage_type, self)
	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null and is_instance_valid(_current_swipe_area):
		CombatTelemetry.record_contact(receiver, _current_swipe_area, self, before)
