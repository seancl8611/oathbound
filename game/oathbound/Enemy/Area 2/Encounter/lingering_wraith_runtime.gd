extends "res://Enemy/Area 2/Encounter/lingering_wraith.gd"

## Runtime range hardening for the live Area 2 Lingering Wraith.
##
## Full-run telemetry on September 4 showed ordinary Lingering Wraith sword windups
## beginning around 160-178 px from Akio. The base selector used charge_max_range as
## the generic attack-start gate, so BASIC/THRUST/CROSS remained eligible anywhere the
## 180 px perilous charge was eligible. Keep the authored charge and running gap-close
## reach, but ordinary sword attacks may only begin inside attack_start_max_range.


func _can_start_wraith_attack(dist: float) -> bool:
	if has_died:
		return false
	if telegraphing or is_attacking or swinging:
		return false
	if ProstheticEffects.is_confused(self):
		return false
	return _has_legal_attack_at_distance(dist)


func _has_legal_attack_at_distance(dist: float) -> bool:
	# Kept as a pure range/cooldown seam so runtime regression tests can validate the
	# actual selection boundary without status-effect or scene-ready state influencing
	# the result. _can_start_wraith_attack() remains the gameplay gate and applies all
	# ordinary death/attack/confusion guards before delegating here.
	var normal_ready := dist >= attack_start_min_range and dist <= attack_start_max_range
	var running_ready := dist >= running_min_distance and dist <= _running_start_max_range()
	var charge_ready := _charge_available_at_distance(dist)
	return normal_ready or running_ready or charge_ready


func _select_wraith_attack(dist: float) -> int:
	var normal_ready := dist >= attack_start_min_range and dist <= attack_start_max_range
	var running_ready := dist >= running_min_distance and dist <= _running_start_max_range()
	var charge_ready := _charge_available_at_distance(dist)

	var weights := {
		WraithAttack.BASIC_SWING: 0.28 if normal_ready else 0.0,
		WraithAttack.QUICK_THRUST: 0.24 if normal_ready else 0.0,
		WraithAttack.CROSS_SWING: 0.22 if normal_ready else 0.0,
		WraithAttack.RUNNING_SWING: 0.22 if running_ready else 0.0,
		WraithAttack.PERILOUS_CHARGE: charge_chance if charge_ready else 0.0,
	}

	if dist < 35.0:
		weights[WraithAttack.RUNNING_SWING] = 0.0
		weights[WraithAttack.PERILOUS_CHARGE] = 0.0

	if weights.has(_last_attack):
		weights[_last_attack] = float(weights[_last_attack]) * 0.35

	var total := 0.0
	for value: Variant in weights.values():
		total += float(value)

	# _can_start_wraith_attack() guarantees a legal option before this selector is
	# called. Keep a defensive fallback that never turns a far-range failure into an
	# impossible basic swing.
	if total <= 0.001:
		if charge_ready:
			_last_attack = WraithAttack.PERILOUS_CHARGE
			return WraithAttack.PERILOUS_CHARGE
		if running_ready:
			_last_attack = WraithAttack.RUNNING_SWING
			return WraithAttack.RUNNING_SWING
		_last_attack = WraithAttack.BASIC_SWING
		return WraithAttack.BASIC_SWING

	var roll := randf() * total
	var cumulative := 0.0
	for attack_type: Variant in weights.keys():
		cumulative += float(weights[attack_type])
		if roll <= cumulative:
			_last_attack = int(attack_type)
			return int(attack_type)

	if charge_ready:
		_last_attack = WraithAttack.PERILOUS_CHARGE
		return WraithAttack.PERILOUS_CHARGE
	if running_ready:
		_last_attack = WraithAttack.RUNNING_SWING
		return WraithAttack.RUNNING_SWING
	_last_attack = WraithAttack.BASIC_SWING
	return WraithAttack.BASIC_SWING


func _charge_available_at_distance(dist: float) -> bool:
	var now := Time.get_ticks_msec() * 0.001
	return (now - _last_charge_time) >= charge_cooldown and dist >= charge_min_range and dist <= charge_max_range


func _running_start_max_range() -> float:
	# The running swing may start farther out than ordinary sword attacks because its
	# authored lunge closes distance before the active circle reaches Akio.
	return running_range + running_radius + running_lunge_speed * running_lunge_time
