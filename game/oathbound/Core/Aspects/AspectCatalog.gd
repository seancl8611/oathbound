extends RefCounted
class_name AspectCatalog

## Canonical first-playtest Blood Aspect weapon-kit data.
## Values come from docs/gameplay/ASPECT_IMPLEMENTATION_BASELINES.md.

const WOLF := "wolf"
const WRAITH := "wraith"
const RONIN := "ronin"
const ASPECTS := [WOLF, WRAITH, RONIN]

static func get_basic_profiles(aspect: String, tier: int = 0) -> Array:
	match aspect:
		WOLF:
			return [
				_profile("wolf_fang_slash", "Fang Slash", "basic", 12, 10.0, 14.0, 0.14, 0.08, 0.20, "attack", "slash_small", Vector2(0.92, 0.92), 22.0, 120.0, 0.15, true),
				_profile("wolf_rending_cross", "Rending Cross", "basic", 13, 12.0, 16.0, 0.16, 0.10, 0.22, "attack_2", "slash_wide", Vector2(1.18, 1.06), 24.0, 70.0, 0.10, true),
				_profile("wolf_raking_fang", "Raking Fang", "basic", 15, 15.0, 20.0, 0.18, 0.09, 0.26, "attack_2", "dash_forward", Vector2(0.95, 1.15), 27.0, 300.0, 0.18, true),
				_profile("wolf_blood_cleave", "Blood Cleave", "basic", 22, 24.0, 34.0, 0.26, 0.13, 0.42, "attack_3", "cleave_heavy", Vector2(1.45, 1.18), 29.0, 70.0, 0.10, false),
			]
		WRAITH:
			return [
				_profile("wraith_veil_cut", "Veil Cut", "basic", 13, 12.0, 15.0, 0.18, 0.09, 0.22, "attack", "thrust_long", Vector2(1.55, 0.52), 30.0, 18.0, 0.08, true, 58.0, true),
				_profile("wraith_passing_arc", "Passing Arc", "basic", 15, 18.0, 26.0, 0.24, 0.12, 0.32, "attack_2", "slash_wide", Vector2(1.58, 1.25), 30.0, 12.0, 0.08, false, 60.0, true),
			]
		RONIN:
			return [
				_profile("ronin_severing_cut", "Severing Cut", "basic", 18, 18.0, 24.0, 0.24, 0.10, 0.30, "attack", "slash_small", Vector2(1.16, 1.06), 25.0, 20.0, 0.08, true),
				_profile("ronin_crushing_cross", "Crushing Cross", "basic", 22, 24.0, 34.0, 0.32, 0.12, 0.38, "attack_2", "slash_wide", Vector2(1.34, 1.18), 27.0, 15.0, 0.08, true),
				_profile("ronin_bloodfall", "Bloodfall", "basic", 30, 34.0, 48.0, 0.42, 0.14, 0.55, "attack_3", "cleave_heavy", Vector2(1.58, 1.30), 30.0, 8.0, 0.08, false),
			]
	return []

static func get_held_profile(aspect: String, tier: int = 0) -> Dictionary:
	match aspect:
		WOLF:
			return _profile("wolf_predators_passage", "Predator's Passage", "held", 28, 30.0, 42.0, 0.45, 0.10, 0.50, "thrust", "thrust_long", Vector2(1.18, 0.75), 32.0, 500.0, 0.30, false)
		WRAITH:
			var reach_scale := 3.20 if tier >= 4 else 2.35
			return _profile("wraith_pale_lance", "Pale Lance", "held", 24, 24.0, 34.0, 0.38, 0.10, 0.42, "thrust", "thrust_long", Vector2(reach_scale, 0.42), 34.0, 5.0, 0.05, false, 72.0, tier >= 4)
		RONIN:
			return _profile("ronin_stillness_draw", "Stillness Draw", "held", 38, 42.0, 58.0, 0.60, 0.12, 0.60, "thrust", "thrust_long", Vector2(1.55, 0.55), 31.0, 4.0, 0.05, false)
	return {}

static func get_dash_profile(aspect: String, tier: int = 0) -> Dictionary:
	match aspect:
		WOLF:
			return _profile("wolf_hunting_slash", "Hunting Slash", "dash", 15, 13.0, 18.0, 0.10, 0.09, 0.20, "dash_slash", "dash_forward", Vector2(1.02, 1.22), 28.0, 300.0, 0.15, true)
		WRAITH:
			var reach_scale := 2.15 if tier >= 4 else 1.75
			return _profile("wraith_ghostline_slash", "Ghostline Slash", "dash", 13, 12.0, 16.0, 0.12, 0.08, 0.18, "dash_slash", "thrust_long", Vector2(reach_scale, 0.58), 31.0, 25.0, 0.06, true, 68.0, tier >= 4)
		RONIN:
			return _profile("ronin_breaching_slash", "Breaching Slash", "dash", 14, 12.0, 16.0, 0.14, 0.09, 0.22, "dash_slash", "slash_small", Vector2(1.10, 1.00), 24.0, 30.0, 0.08, true)
	return {}

static func get_counter_profile(aspect: String, tier: int = 0) -> Dictionary:
	match aspect:
		WOLF:
			return _profile("wolf_fang_reversal", "Fang Reversal", "counter", 16, 24.0, 32.0, 0.10, 0.08, 0.24, "counter_cut", "counter_short", Vector2(1.18, 1.02), 24.0, 120.0, 0.10, true)
		WRAITH:
			return _profile("wraith_veil_reversal", "Veil Reversal", "counter", 15, 28.0, 38.0, 0.12, 0.09, 0.24, "counter_cut", "thrust_long", Vector2(1.82, 0.62), 31.0, 15.0, 0.06, true, 65.0, true)
		RONIN:
			return _profile("ronin_answering_steel", "Answering Steel", "counter", 26, 34.0, 46.0, 0.16, 0.10, 0.32, "counter_cut", "counter_short", Vector2(1.35, 1.10), 27.0, 12.0, 0.06, true)
	return {}

static func get_reprisal_profile() -> Dictionary:
	return _profile("ronin_reprisal_cut", "Reprisal Cut", "basic", 24, 28.0, 38.0, 0.30, 0.12, 0.46, "attack_3", "cleave_heavy", Vector2(1.32, 1.16), 27.0, 4.0, 0.05, false)

static func get_wraith_barrage_profile() -> Dictionary:
	var p := _profile("wraith_pale_barrage", "Pale Barrage", "held", 7, 6.0, 8.0, 0.07, 0.05, 0.08, "thrust", "thrust_long", Vector2(2.20, 0.35), 34.0, 0.0, 0.0, false, 72.0, false)
	p["proc_coefficient"] = 0.30
	return p

static func get_blood_art_profile(aspect: String) -> Dictionary:
	match aspect:
		WOLF:
			var p := _profile("wolf_blood_hunt", "Blood Hunt", "blood_art", 12, 18.0, 22.0, 0.12, 0.22, 0.28, "dash_slash", "dash_forward", Vector2(1.45, 1.45), 28.0, 640.0, 0.50, false)
			p["blood_generation"] = false
			return p
		WRAITH:
			var p := _profile("wraith_reach_corridor", "Wraith's Reach", "blood_art", 24, 30.0, 40.0, 0.18, 0.14, 0.32, "thrust", "thrust_long", Vector2(4.75, 0.70), 38.0, 0.0, 0.0, false)
			p["blood_generation"] = false
			return p
		RONIN:
			var p := _profile("ronin_falling_mountain", "Falling Mountain", "blood_art", 48, 55.0, 70.0, 0.46, 0.16, 0.62, "attack_3", "cleave_heavy", Vector2(1.82, 1.48), 31.0, 0.0, 0.0, false)
			p["blood_generation"] = false
			return p
	return {}

static func blood_multiplier(aspect: String) -> float:
	match aspect:
		WOLF: return 0.90
		WRAITH: return 1.00
		RONIN: return 1.10
	return 1.0

static func max_posture(aspect: String, tier: int) -> float:
	if aspect == RONIN:
		return 120.0 + 10.0 * clampi(tier, 0, 4)
	return 100.0

static func posture_recovery_rate(aspect: String) -> float:
	return 18.0 if aspect == RONIN else 25.0

static func posture_recovery_delay(aspect: String) -> float:
	return 1.0 if aspect == RONIN else 0.75

static func block_posture_multiplier(aspect: String) -> float:
	return 0.85 if aspect == RONIN else 1.0

static func feral_bonus(combo_index: int, tier: int) -> float:
	if tier <= 0:
		return 0.0
	var tier_growth := 0.025 * float(maxi(0, tier - 1))
	match combo_index:
		1: return 0.05 + tier_growth
		2: return 0.10 + tier_growth
		3: return 0.15 + tier_growth
	return 0.0

static func _profile(id: String, display_name: String, trigger: String, health: int, posture: float, block_posture: float, startup: float, active: float, recovery: float, anim: String, shape: String, scale: Vector2, offset: float, lunge_speed: float, lunge_time: float, can_combo: bool, spectral_min_range: float = 0.0, spectral_edge: bool = false) -> Dictionary:
	var duration := startup + active + recovery
	return {
		"id": id,
		"display_name": display_name,
		"action_trigger": trigger,
		"anim": anim,
		"anim_speed": 1.0,
		"duration": duration,
		"startup": startup,
		"active": active,
		"recovery": recovery,
		"queue_start": clampf((startup + active * 0.4) / maxf(duration, 0.001), 0.25, 0.80),
		"combo_start": clampf((startup + active * 0.5) / maxf(duration, 0.001), 0.30, 0.85),
		"combo_end": 0.95,
		"cancel_at": 0.86,
		"lunge_start": startup,
		"lunge_speed": lunge_speed,
		"lunge_time": lunge_time,
		"health_damage": health,
		"damage": health,
		"posture_damage": posture,
		"posture": posture,
		"block_posture_damage": block_posture,
		"stagger_level": 1 if posture >= 24.0 else 0,
		"proc_coefficient": 1.0,
		"knockback": 110.0 + posture * 2.0,
		"hitstop": clampf(0.055 + posture * 0.0022, 0.06, 0.18),
		"hitbox_offset": offset,
		"hitbox_shape": shape,
		"hitbox_scale": scale,
		"shake": clampf(2.0 + posture * 0.12, 2.0, 8.0),
		"can_combo": can_combo,
		"restart_lockout": maxf(0.10, recovery * 0.55),
		"blood_generation": trigger != "blood_art",
		"spectral_min_range": spectral_min_range,
		"spectral_edge": spectral_edge,
		"aspect_passage": aspect_passage_eligible(id),
	}

static func aspect_passage_eligible(id: String) -> bool:
	return id in ["wraith_veil_cut", "wraith_passing_arc", "wraith_pale_lance", "wraith_ghostline_slash", "wraith_veil_reversal"]
