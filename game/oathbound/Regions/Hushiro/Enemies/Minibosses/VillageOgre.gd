extends "res://Regions/Hushiro/Enemies/Minibosses/VillageOgreController.gd"

## Canonical Hushiro rules layer for Village Ogre.
## The imported controller owns animation and attack execution; this layer owns the
## approved first-playtest contract in HUSHIRO_IMPLEMENTATION_BASELINE.md.

const HUSHIRO_MAX_HEALTH := 650
const HUSHIRO_MAX_POSTURE := 350.0
const HUSHIRO_DEATHBLOW_WINDOW := 3.0
const HUSHIRO_POSTURE_RESET_RATIO := 0.50
const HUSHIRO_LONG_RANGE := 170.0

var _hushiro_finisher_kill := false
var _hushiro_last_major_attack: int = -1
var _hushiro_repeat_count := 0
var _hushiro_base_min_cooldown := 0.0
var _hushiro_base_max_cooldown := 0.0
var _hushiro_base_combo_weight := 0.0
var _hushiro_base_sweep_weight := 0.0


func _ready() -> void:
	super._ready()

	ogre_max_hp = HUSHIRO_MAX_HEALTH
	hp = HUSHIRO_MAX_HEALTH
	_max_hp = HUSHIRO_MAX_HEALTH
	deathblow_window_duration = HUSHIRO_DEATHBLOW_WINDOW
	deathblow_instant_kill = true
	deathblow_pips = 1

	# Cannonfire Mark is an imported prototype move and is not part of the approved
	# Village Ogre roster. Spinning Sweep remains the controller's HAMMER_SPIN path.
	cannon_base_chance = 0.0
	_cannon_desire = 0.0
	spin_min_range = 0.0

	_hushiro_base_min_cooldown = min_attack_cooldown
	_hushiro_base_max_cooldown = max_attack_cooldown
	_hushiro_base_combo_weight = combo_base_chance
	_hushiro_base_sweep_weight = spin_base_chance

	if combat:
		combat.config = CombatConfig.create_miniboss_config()
		combat.config.posture_max = HUSHIRO_MAX_POSTURE
		combat.config.posture_break_duration = HUSHIRO_DEATHBLOW_WINDOW
		combat.config.posture_break_reset_ratio = HUSHIRO_POSTURE_RESET_RATIO
		combat.set_posture(0.0)

	_update_bars()
	print("[VillageOgre] Hushiro contract active: 650 Health / 350 Posture")


func _physics_process(delta: float) -> void:
	_apply_hushiro_low_health_escalation()
	super._physics_process(delta)


func _apply_hushiro_low_health_escalation() -> void:
	var escalated := float(hp) / float(maxi(1, get_max_hp())) < 0.50
	if escalated:
		# Approved escalation is decision pressure only: ~15% less idle delay plus
		# greater combo/sweep preference. Do not globally speed movement/animations.
		min_attack_cooldown = _hushiro_base_min_cooldown * 0.85
		max_attack_cooldown = _hushiro_base_max_cooldown * 0.85
		combo_base_chance = _hushiro_base_combo_weight * 1.35
		spin_base_chance = _hushiro_base_sweep_weight * 1.50
	else:
		min_attack_cooldown = _hushiro_base_min_cooldown
		max_attack_cooldown = _hushiro_base_max_cooldown
		combo_base_chance = _hushiro_base_combo_weight
		spin_base_chance = _hushiro_base_sweep_weight


func _choose_attack(dist: float) -> AttackType:
	# Approved roster only: Shield Advance, Overhead Crush, Three-Hit Crush Combo,
	# and Spinning Sweep. Repeated entries provide simple authored weighting.
	var candidates: Array[AttackType] = []

	if dist > HUSHIRO_LONG_RANGE:
		candidates.append(AttackType.SHIELD_ADVANCE)
		candidates.append(AttackType.SHIELD_ADVANCE)
		candidates.append(AttackType.SHIELD_ADVANCE)
	else:
		candidates.append(AttackType.OVERHEAD_BREAKER)
		candidates.append(AttackType.OVERHEAD_BREAKER)
		candidates.append(AttackType.TRIPLE_COMBO)
		candidates.append(AttackType.TRIPLE_COMBO)
		if dist > close_range:
			candidates.append(AttackType.SHIELD_ADVANCE)

	if _hushiro_can_use_sweep(dist):
		candidates.append(AttackType.HAMMER_SPIN)
		candidates.append(AttackType.HAMMER_SPIN)
		if float(hp) / float(maxi(1, get_max_hp())) < 0.50:
			candidates.append(AttackType.HAMMER_SPIN)
			candidates.append(AttackType.TRIPLE_COMBO)

	var legal: Array[AttackType] = []
	for attack: AttackType in candidates:
		if not _would_repeat_major_attack(attack):
			legal.append(attack)

	if legal.is_empty():
		legal.append(AttackType.SHIELD_ADVANCE if dist > HUSHIRO_LONG_RANGE else AttackType.OVERHEAD_BREAKER)

	var chosen: AttackType = legal[_rng.randi_range(0, legal.size() - 1)]
	_on_attack_chosen(chosen)
	return chosen


func _hushiro_can_use_sweep(dist: float) -> bool:
	if _spin_cooldown > 0.0 or dist > close_range * 1.20:
		return false
	var player := _get_player()
	if player == null or not is_instance_valid(player):
		return false
	# Sweep is specifically favored when Akio lingers on the Ogre's flank/rear.
	return not _is_frontal_attack_pos(player.global_position)


func _would_repeat_major_attack(attack: AttackType) -> bool:
	return int(attack) == _hushiro_last_major_attack and _hushiro_repeat_count >= 2


func _start_attack(attack: AttackType) -> void:
	var resolved: AttackType = attack

	# Imported Cannonfire Mark is deliberately retired from the current Hushiro fight.
	if resolved == AttackType.CANNONFIRE_MARK:
		var player := _get_player()
		var dist := HUSHIRO_LONG_RANGE + 1.0
		if player != null and is_instance_valid(player):
			dist = global_position.distance_to(player.global_position)
		resolved = AttackType.SHIELD_ADVANCE if dist > HUSHIRO_LONG_RANGE else AttackType.OVERHEAD_BREAKER

	if _would_repeat_major_attack(resolved):
		resolved = _fallback_major_attack(resolved)

	if int(resolved) == _hushiro_last_major_attack:
		_hushiro_repeat_count += 1
	else:
		_hushiro_last_major_attack = int(resolved)
		_hushiro_repeat_count = 1

	super._start_attack(resolved)


func _fallback_major_attack(blocked_attack: AttackType) -> AttackType:
	var player := _get_player()
	var dist := 0.0
	if player != null and is_instance_valid(player):
		dist = global_position.distance_to(player.global_position)
	if dist > HUSHIRO_LONG_RANGE and blocked_attack != AttackType.SHIELD_ADVANCE:
		return AttackType.SHIELD_ADVANCE
	if blocked_attack != AttackType.OVERHEAD_BREAKER:
		return AttackType.OVERHEAD_BREAKER
	return AttackType.TRIPLE_COMBO


func _apply_damage(damage: int, damage_type: String, attacker: Node) -> void:
	if _hushiro_finisher_kill:
		super._apply_damage(damage, damage_type, attacker)
		return

	# Health depletion is a Deathblow opportunity, not an automatic miniboss death.
	if damage > 0 and hp - damage <= 0:
		var effective_damage := maxi(hp - 1, 0)
		if effective_damage > 0:
			super._apply_damage(effective_damage, damage_type, attacker)
		hp = maxi(hp, 1)
		_update_bars()
		if not _dbroken_active:
			_on_posture_broken(HUSHIRO_DEATHBLOW_WINDOW)
		return

	super._apply_damage(damage, damage_type, attacker)


func _end_deathblow_window() -> void:
	if not _dbroken_active:
		return
	super._end_deathblow_window()
	hp = maxi(hp, 1)
	if combat and combat.config:
		combat.set_posture(combat.config.posture_max * HUSHIRO_POSTURE_RESET_RATIO)
	_update_bars()


func take_deathblow(attacker: Node) -> void:
	if _phase == Phase.DEAD or not _dbroken_active or _deathblow_in_progress:
		return
	_hushiro_finisher_kill = true
	deathblow_instant_kill = true
	deathblow_pips = 1
	super.take_deathblow(attacker)
	_hushiro_finisher_kill = false
