extends RefCounted
class_name CounterCueTiming

## Single player-facing timing authority for enemy attack prompts.
##
## Every tracked enemy still owns its authored attack animation/timing. This adapter
## translates legacy `_show_parry_indicator(...)` arguments into one meaning:
## seconds until the attack can first contact Akio. The indicator then applies the
## same two beats everywhere in the game.

const WARNING_LEAD_SECONDS: float = 0.20
const PARRY_BEAT_LEAD_SECONDS: float = 0.12
const MIN_OFFSET_SECONDS: float = 0.001


static func resolve_impact_offsets(owner: Node, legacy_duration: float) -> Array[float]:
	var fallback := maxf(MIN_OFFSET_SECONDS, legacy_duration)
	if owner == null:
		return [fallback]

	var path := _script_path(owner)
	var impacts: Array[float] = []

	# Hushiro standard roster.
	if path.ends_with("CorruptedSwordsmanController.gd"):
		impacts = _swordsman_impacts(owner, fallback)
	elif path.ends_with("BlightedHound.gd") or path.ends_with("stalker_hound.gd") or path.ends_with("stalker_hound_runtime.gd"):
		impacts = _hound_impacts(owner, fallback)
	elif path.ends_with("Hollow.gd"):
		impacts = [fallback - _f(owner, "bite_active_time", 0.13)]
	elif path.ends_with("WardenController.gd"):
		impacts = [fallback - _warden_active_time(owner)]
	elif path.ends_with("CorruptedArcherController.gd"):
		impacts = [_projectile_eta(owner, _f(owner, "aim_duration", fallback), _f(owner, "projectile_speed", 140.0), 0.0)]
	elif path.ends_with("TheCollectorController.gd"):
		impacts = _collector_impacts(owner, fallback)
	elif path.ends_with("VillageOgreController.gd"):
		impacts = _ogre_impacts(owner, fallback)
	elif path.ends_with("KeeperController.gd"):
		impacts = _keeper_impacts(owner, fallback)

	# Yomori / Area 2 roster. Runtime wrappers expose the same authored properties.
	elif path.ends_with("rootfang.gd") or path.ends_with("rootfang_runtime.gd"):
		impacts = _rootfang_impacts(owner, fallback)
	elif path.ends_with("briarthorn.gd") or path.ends_with("briarthorn_runtime.gd"):
		impacts = _briarthorn_impacts(owner, fallback)
	elif path.ends_with("rotwood_host.gd") or path.ends_with("rotwood_host_runtime.gd"):
		impacts = _rotwood_impacts(owner, fallback)
	elif path.ends_with("embered_pilgrim.gd") or path.ends_with("embered_pilgrim_runtime.gd"):
		impacts = _pilgrim_impacts(owner, fallback)
	elif path.ends_with("lantern_wraith.gd"):
		impacts = [_projectile_eta(owner, _f(owner, "aim_duration", fallback), _f(owner, "projectile_speed", 230.0), 0.0)]
	elif path.ends_with("lingering_wraith.gd") or path.ends_with("lingering_wraith_runtime.gd"):
		impacts = _generic_wraith_impacts(owner, fallback)
	elif path.ends_with("Mist_Shepherd.gd"):
		impacts = [fallback]

	# Kagutsuchi roster.
	elif path.ends_with("CourtGuard.gd"):
		# Court Guard already passes exactly one windup per sword beat.
		impacts = [fallback]
	elif path.ends_with("CourtCaster.gd"):
		impacts = _court_caster_impacts(owner)
	elif path.ends_with("CourtSentinel.gd"):
		impacts = _court_sentinel_impacts(owner, fallback)
	elif path.ends_with("EliteDefender.gd"):
		impacts = _elite_defender_impacts(owner, fallback)
	elif path.ends_with("EclipseShogun.gd") or path.ends_with("EclipseShogunRuntime.gd"):
		impacts = _shogun_impacts(owner, fallback)
	else:
		# The repository-wide smoke rejects unregistered live call sites. Keep a safe
		# fallback here so an editor-only/prototype caller does not crash at runtime.
		impacts = [fallback]

	return _sanitize_offsets(impacts, fallback)


static func supports_script_path(path: String) -> bool:
	var suffixes: Array[String] = [
		"CorruptedSwordsmanController.gd",
		"BlightedHound.gd",
		"stalker_hound.gd",
		"stalker_hound_runtime.gd",
		"Hollow.gd",
		"WardenController.gd",
		"CorruptedArcherController.gd",
		"TheCollectorController.gd",
		"VillageOgreController.gd",
		"KeeperController.gd",
		"rootfang.gd",
		"rootfang_runtime.gd",
		"briarthorn.gd",
		"briarthorn_runtime.gd",
		"rotwood_host.gd",
		"rotwood_host_runtime.gd",
		"embered_pilgrim.gd",
		"embered_pilgrim_runtime.gd",
		"lantern_wraith.gd",
		"lingering_wraith.gd",
		"lingering_wraith_runtime.gd",
		"Mist_Shepherd.gd",
		"CourtGuard.gd",
		"CourtCaster.gd",
		"CourtSentinel.gd",
		"EliteDefender.gd",
		"EclipseShogun.gd",
		"EclipseShogunRuntime.gd",
	]
	for suffix: String in suffixes:
		if path.ends_with(suffix):
			return true
	return false


static func _swordsman_impacts(owner: Node, legacy: float) -> Array[float]:
	var active := _f(owner, "active_window", 0.15)
	var override_id := _s(owner, "_hushiro_attack_id_override", "")
	if override_id == "cross_swing_2":
		return [legacy - active - 0.15]
	if override_id.begins_with("thrust_followup_"):
		return [legacy - active - 0.10]

	var attack := _i(owner, "_current_attack_type", 0)
	match attack:
		0: # BASIC_SWING
			return [legacy - active - 0.15]
		1: # QUICK_THRUST
			return [legacy - _f(owner, "thrust_lunge_time", 0.18) - 0.20]
		2: # CROSS_SWING opening beat
			var second_windup := maxf(_f(owner, "cross_swing_hit_delay", 0.45), 0.45)
			return [legacy - active - second_windup - active - 0.20]
		3: # RUNNING_SWING includes its committed approach before windup.
			return [legacy - active - 0.20]
	return [legacy]


static func _hound_impacts(owner: Node, legacy: float) -> Array[float]:
	if _b(owner, "_mist_pounce_active", false):
		return [_f(owner, "mist_pounce_windup", legacy)]
	var bite_total := _f(owner, "bite_windup", 0.35) + _f(owner, "bite_active_time", 0.13) + 0.15
	if absf(legacy - bite_total) <= 0.04:
		return [_f(owner, "bite_windup", legacy)]
	return [legacy - _f(owner, "lunge_active_time", 0.18) - 0.10]


static func _warden_active_time(owner: Node) -> float:
	match _i(owner, "_current_attack", 0):
		0:
			return _f(owner, "chain_active_time", 0.15)
		1:
			return _f(owner, "thrust_active_time", 0.13)
		2:
			return _f(owner, "cross_active_time", 0.14)
		3:
			return _f(owner, "running_active_time", 0.16)
	return 0.15


static func _collector_impacts(owner: Node, legacy: float) -> Array[float]:
	var attack := _i(owner, "_current_attack", 0)
	var linger := _f(owner, "parry_linger_window", 0.20)
	var ambush := _b(owner, "_is_ambushing", false)
	match attack:
		1: # GREED_LASH - normal path intentionally arms only in the late windup.
			return [legacy - _f(owner, "lash_active", 0.13) - linger]
		2: # SOUL_CHAIN_SNARE
			if ambush:
				return [_f(owner, "snare_windup", 0.65) * (1.0 - _f(owner, "ambush_windup_reduction", 0.25))]
			return [_f(owner, "snare_windup", 0.65)]
		4: # CHAIN_COMBO
			var index := maxi(1, _i(owner, "_combo_hit_index", 1))
			var active_name := "combo_hit%d_active" % mini(index, 4)
			var active := _f(owner, active_name, 0.12)
			if ambush and index == 1:
				return [_f(owner, "combo_hit1_windup", 0.55) * (1.0 - _f(owner, "ambush_windup_reduction", 0.25))]
			return [legacy - active - linger]
		5: # GROUND_MASSES
			return [_f(owner, "masses_windup", 0.60)]
		6: # QUICK_SLASH
			if ambush:
				return [_f(owner, "quick_slash_windup", 0.38) * (1.0 - _f(owner, "ambush_windup_reduction", 0.25))]
			return [legacy - _f(owner, "quick_slash_active", 0.11) - linger]
	return [legacy]


static func _ogre_impacts(owner: Node, legacy: float) -> Array[float]:
	match _i(owner, "_current_attack", -1):
		0: # SHIELD_ADVANCE
			return [_f(owner, "shield_advance_windup", 0.55)]
		1: # OVERHEAD_BREAKER - hitbox becomes parryable before the slam frame.
			return [maxf(MIN_OFFSET_SECONDS, _f(owner, "overhead_windup_time", 0.95) - _f(owner, "overhead_parry_preframe", 0.12))]
		2: # CANNONFIRE_MARK
			return [0.30]
		3: # HAMMER_SPIN
			return [0.50]
		4: # TRIPLE_COMBO
			var hit := _i(owner, "_combo_hit_index", 1)
			if hit <= 1:
				return [_f(owner, "combo1_anticipation", 0.30)]
			if hit == 2:
				return [_f(owner, "combo2_anticipation", 0.42)]
			return [_f(owner, "combo_finisher_windup", 0.55)]
	return [legacy]


static func _keeper_impacts(owner: Node, legacy: float) -> Array[float]:
	var attack := _i(owner, "_current_attack", 0)
	var linger := _f(owner, "parry_linger_window", 0.18)
	match attack:
		1: # BLADE_DANCE
			return [legacy - _active_for_legacy(owner, legacy, linger) - linger]
		2: # EMBER_OVERHEAD
			return [_f(owner, "overhead_windup", 0.90)]
		3: # PERILOUS_THRUST
			return [_f(owner, "thrust_telegraph_time", 0.70)]
		4: # PERILOUS_SWEEP
			return [_f(owner, "sweep_telegraph_time", 0.48)]
		5: # IAIJUTSU_DRAW - each call is a separate beat.
			if legacy <= _f(owner, "iaijutsu_hit2_anticipation", 0.20) + _f(owner, "iaijutsu_hit2_active", 0.14) + linger + 0.03:
				return [_f(owner, "iaijutsu_hit2_anticipation", 0.20)]
			return [_f(owner, "iaijutsu_windup", 0.55)]
		6: # DISCIPLINE_CUT
			return [_f(owner, "discipline_windup", 0.28)]
		7: # FERAL_ONSLAUGHT
			return [legacy - _f(owner, "feral_active_time", 0.12) - linger]
		8: # SAVAGE_SWEEP
			return [_f(owner, "savage_telegraph_time", 0.58)]
		9: # LEAPING_SLAM
			return [_f(owner, "slam_crouch_time", 0.70) + _f(owner, "slam_air_time", 0.50) + _f(owner, "slam_landing_delay", 0.25)]
		10: # BLOODIED_LUNGE
			return [_f(owner, "lunge_telegraph_time", 0.65)]
	return [legacy]


static func _active_for_legacy(owner: Node, legacy: float, linger: float) -> float:
	# Keeper Blade Dance active windows vary slightly by hit. Find the authored one
	# that makes the remaining anticipation plausible without coupling the cue visual
	# to that active duration.
	var candidates: Array[float] = [
		_f(owner, "blade_dance_hit1_active", 0.12),
		_f(owner, "blade_dance_hit2_active", 0.12),
		_f(owner, "blade_dance_hit3_active", 0.15),
		_f(owner, "blade_dance_hit4_active", 0.14),
	]
	var best := candidates[0]
	var best_error := INF
	for active: float in candidates:
		var remaining := legacy - active - linger
		var error := absf(remaining - clampf(remaining, 0.18, 0.60))
		if error < best_error:
			best_error = error
			best = active
	return best


static func _rootfang_impacts(owner: Node, legacy: float) -> Array[float]:
	if _b(owner, "_is_rootfanged", false):
		var roll_time := _f(owner, "rootfang_roll_distance", 280.0) / maxf(1.0, _f(owner, "rootfang_roll_speed", 450.0))
		return [legacy - roll_time]
	match _i(owner, "_current_attack", 0):
		1: # CLAW_COMBO
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "claw_active", 0.12) - _f(owner, "parry_linger_window", 0.20)]
		2: # LUNGE
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "lunge_active", 0.14) - _f(owner, "parry_linger_window", 0.20)]
		3: # HEAVY_SLAM
			return [legacy - _f(owner, "parry_linger_window", 0.20)]
		4: # EMPOWERED_BEAM
			return [legacy - 0.15]
	return [legacy]


static func _briarthorn_impacts(owner: Node, legacy: float) -> Array[float]:
	match _i(owner, "_current_attack", 0):
		1, 4: # Ground/double AOE use their ground warnings rather than this cue.
			return [legacy]
		2: # LINE_BEAM
			return [legacy - 0.15]
		3: # TAIL_SWIPE
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "swipe_active", 0.10) - _f(owner, "parry_linger_window", 0.18)]
		5: # EMPOWERED_LUNGE
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "emp_lunge_active", 0.12) - _f(owner, "parry_linger_window", 0.18)]
	# Briarthorn sweep is called while rooted with no normal attack enum.
	if _b(owner, "_is_rooted", false) and absf(legacy - _f(owner, "sweep_duration", 2.5)) < 0.05:
		return [WARNING_LEAD_SECONDS]
	return [legacy]


static func _rotwood_impacts(owner: Node, legacy: float) -> Array[float]:
	match _i(owner, "_current_attack", 0):
		1: # CLAW_FLURRY
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "claw_active", 0.12) - _f(owner, "parry_linger_window", 0.20)]
		2: # LUNGING_BITE
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "bite_active", 0.14) - _f(owner, "parry_linger_window", 0.20)]
		3: # TAIL_LASH
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "tail_active", 0.12) - _f(owner, "parry_linger_window", 0.20)]
		4: # RISING_SLAM
			return [maxf(MIN_OFFSET_SECONDS, legacy - _f(owner, "parry_linger_window", 0.20) - _f(owner, "slam_parry_preframe", 0.10))]
		6: # POUNCE - parent waits a fixed coil before the damaging leap.
			return [0.25 * _attack_speed_mult(owner)]
	return [legacy]


static func _pilgrim_impacts(owner: Node, legacy: float) -> Array[float]:
	match _i(owner, "_current_attack", 0):
		1: # NORMAL_SWINGS
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "swing_active", 0.15) - _f(owner, "parry_linger_window", 0.20)]
		2: # OVERHEAD_SLAM; hitbox is intentionally armed pre-impact.
			return [maxf(MIN_OFFSET_SECONDS, _f(owner, "overhead_windup", 0.85) * _attack_speed_mult(owner) - _f(owner, "overhead_parry_preframe", 0.12))]
		3: # ASH_STOMP
			return [_f(owner, "stomp_telegraph", 0.30) * _attack_speed_mult(owner)]
		4: # PYRE_SWEEP
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "sweep_active", 0.18) - _f(owner, "parry_linger_window", 0.20)]
		5: # BURNING_THRUST
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "thrust_active", 0.15) - _f(owner, "parry_linger_window", 0.20)]
		6: # DARK_ORBS
			return [_projectile_eta(owner, _f(owner, "orb_telegraph", 0.60) * _attack_speed_mult(owner), _f(owner, "orb_speed", 280.0), 0.0)]
	return [legacy]


static func _generic_wraith_impacts(owner: Node, legacy: float) -> Array[float]:
	# Wraith controllers expose their own attack windups inconsistently but do not
	# append long recovery chains like the legacy Hushiro melee stack. Clamp to the
	# supplied pre-contact delay while preserving the global visual beats.
	return [legacy]


static func _court_caster_impacts(owner: Node) -> Array[float]:
	var travel := _projectile_travel(owner, _f(owner, "orb_speed_override", 120.0), 0.0)
	var interval := _f(owner, "volley_interval", 0.50)
	var channel := _f(owner, "channel_duration", 3.0)
	var impacts: Array[float] = []
	var fire_time := 0.0
	while fire_time < channel - 0.001:
		impacts.append(fire_time + travel)
		fire_time += interval
	return impacts


static func _court_sentinel_impacts(owner: Node, legacy: float) -> Array[float]:
	match _i(owner, "_current_attack", 0):
		1:
			return [_f(owner, "arc_windup", 0.65)]
		2:
			return [_f(owner, "slam_windup", 0.75)]
		3:
			return [_f(owner, "rush_windup", 0.50)]
		4:
			return [_f(owner, "shove_windup", 0.22)]
	return [legacy]


static func _elite_defender_impacts(owner: Node, legacy: float) -> Array[float]:
	var attack := _i(owner, "_current_attack_type", -1)
	if attack == 100: # TRIPLE_THRUST
		var first := _f(owner, "thrust_string_telegraph", 0.42)
		var cadence := _f(owner, "thrust_hit_active", 0.12) + _f(owner, "thrust_hit_gap", 0.28)
		return [first, first + cadence, first + cadence * 2.0]
	if attack == 101: # SPEAR_THROW
		var first_release := _f(owner, "spear_throw_telegraph", 0.28)
		var interval := _f(owner, "spear_throw_interval", 0.45)
		var travel := _projectile_travel(owner, _f(owner, "spear_speed", 80.0), 0.0)
		var count := maxi(1, _i(owner, "spear_count", 3))
		var impacts: Array[float] = []
		for index: int in range(count):
			impacts.append(first_release + interval * float(index) + travel)
		return impacts
	return [legacy]


static func _shogun_impacts(owner: Node, legacy: float) -> Array[float]:
	var attack := _i(owner, "_current_attack", 0)
	var speed_mult := _attack_speed_mult(owner)
	match attack:
		1: # FUNERAL_MEASURE
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "fm_active", 0.14) - _f(owner, "parry_linger_window", 0.20)]
		2: # BLADE_DANCE projectile
			return [_projectile_eta(owner, _f(owner, "bd_telegraph", 0.50) * speed_mult, _f(owner, "bd_projectile_speed", 220.0), _f(owner, "bd_projectile_radius", 22.0))]
		3: # DEATHLY_DASH
			return [_f(owner, "dd_telegraph", 0.55) * speed_mult]
		4: # SCYTHE_RIFT
			return [_f(owner, "sr_telegraph", 0.42) * speed_mult]
		5: # PREDATOR'S_FEINT; call is made for the pounce beat after the fake.
			return [maxf(WARNING_LEAD_SECONDS, _f(owner, "pf_pounce_telegraph", 0.22) * speed_mult)]
		6: # RAVENOUS_REND
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "fm_active", 0.14) - _f(owner, "parry_linger_window", 0.20)]
		8: # TIMELESS_ZONE's embedded swing is runtime-delayed to this global lead.
			return [WARNING_LEAD_SECONDS]
		9: # ECLIPSE_MEASURE
			if _i(owner, "_combo_hit_index", 0) == 3:
				return [maxf(WARNING_LEAD_SECONDS, _f(owner, "em_beast_telegraph", 0.25) * speed_mult)]
			return [legacy - _f(owner, "parry_early_window", 0.12) - _f(owner, "fm_active", 0.14) - _f(owner, "parry_linger_window", 0.20)]
		10: # BLACK_WING_ASCENT
			return [_f(owner, "bwa_telegraph", 0.65) * speed_mult]
		11: # CRIMSON_RIFT_BLOOM
			return [_f(owner, "crb_telegraph", 0.50) * speed_mult]
	return [legacy]


static func _projectile_eta(owner: Node, release_delay: float, speed: float, radius: float) -> float:
	return release_delay + _projectile_travel(owner, speed, radius)


static func _projectile_travel(owner: Node, speed: float, radius: float) -> float:
	if speed <= 0.001:
		return 0.0
	var player_value: Variant = _value(owner, "player", null)
	if not (player_value is Node2D) or not is_instance_valid(player_value):
		return 0.0
	var player_node := player_value as Node2D
	var distance := owner.global_position.distance_to(player_node.global_position)
	return maxf(0.0, distance - radius) / speed


static func _attack_speed_mult(owner: Node) -> float:
	if owner.has_method("_get_attack_speed_mult"):
		var value: Variant = owner.call("_get_attack_speed_mult")
		if value != null:
			return maxf(0.05, float(value))
	return 1.0


static func _sanitize_offsets(values: Array[float], fallback: float) -> Array[float]:
	var sanitized: Array[float] = []
	for value: float in values:
		if not is_finite(value):
			continue
		sanitized.append(maxf(MIN_OFFSET_SECONDS, value))
	if sanitized.is_empty():
		sanitized.append(fallback)
	sanitized.sort()
	return sanitized


static func _script_path(owner: Node) -> String:
	var script_value: Variant = owner.get_script()
	if script_value is Script:
		return (script_value as Script).resource_path
	return ""


static func _value(owner: Object, name: String, fallback: Variant) -> Variant:
	for property_value: Dictionary in owner.get_property_list():
		if String(property_value.get("name", "")) == name:
			return owner.get(name)
	return fallback


static func _f(owner: Object, name: String, fallback: float) -> float:
	var value: Variant = _value(owner, name, fallback)
	return float(value) if value != null else fallback


static func _i(owner: Object, name: String, fallback: int) -> int:
	var value: Variant = _value(owner, name, fallback)
	return int(value) if value != null else fallback


static func _b(owner: Object, name: String, fallback: bool) -> bool:
	var value: Variant = _value(owner, name, fallback)
	return bool(value) if value != null else fallback


static func _s(owner: Object, name: String, fallback: String) -> String:
	var value: Variant = _value(owner, name, fallback)
	return String(value) if value != null else fallback
