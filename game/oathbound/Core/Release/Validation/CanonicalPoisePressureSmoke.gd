extends Node

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const SWORD_HITBOX_SCRIPT = preload("res://Player/SwordHitBox.gd")
const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")

var _failures: Array[String] = []
var _checked_ids: Array[String] = []
var _hitbox: SwordHitBox = null


func _ready() -> void:
	_hitbox = _build_test_hitbox()
	if _hitbox == null:
		_failures.append("could not create SwordHitBox test fixture")
		_finish()
		return

	_validate_profile_set("base_basic", ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_held", ASPECT_CATALOG.get_held_profile(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_dash", ASPECT_CATALOG.get_dash_profile(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_counter", ASPECT_CATALOG.get_counter_profile(ASPECT_CATALOG.NO_ASPECT, 0))

	for aspect: String in ASPECT_CATALOG.ASPECTS:
		_validate_profile_set("%s_basic" % aspect, ASPECT_CATALOG.get_basic_profiles(aspect, 4))
		_validate_profile("%s_held" % aspect, ASPECT_CATALOG.get_held_profile(aspect, 4))
		_validate_profile("%s_dash" % aspect, ASPECT_CATALOG.get_dash_profile(aspect, 4))
		_validate_profile("%s_counter" % aspect, ASPECT_CATALOG.get_counter_profile(aspect, 4))
		_validate_profile("%s_blood_art" % aspect, ASPECT_CATALOG.get_blood_art_profile(aspect))

	_validate_profile("ronin_reprisal", ASPECT_CATALOG.get_reprisal_profile())
	_validate_profile("wraith_barrage", ASPECT_CATALOG.get_wraith_barrage_profile())
	_validate_enemy_runtime_prefers_canonical_poise()
	_finish()


func _build_test_hitbox() -> SwordHitBox:
	var value: Variant = SWORD_HITBOX_SCRIPT.new()
	if not (value is SwordHitBox):
		return null
	var hitbox: SwordHitBox = value as SwordHitBox
	var shape_node := CollisionShape2D.new()
	shape_node.name = "CollisionShape2D"
	shape_node.shape = RectangleShape2D.new()
	hitbox.add_child(shape_node)
	add_child(hitbox)
	return hitbox


func _validate_profile_set(label: String, profiles: Array) -> void:
	if profiles.is_empty():
		_failures.append("%s returned no profiles" % label)
		return
	for value: Variant in profiles:
		if value is Dictionary:
			_validate_profile(label, value as Dictionary)
		else:
			_failures.append("%s contains a non-Dictionary profile" % label)


func _validate_profile(label: String, profile: Dictionary) -> void:
	if profile.is_empty():
		_failures.append("%s returned an empty profile" % label)
		return
	var action_id: String = str(profile.get("id", ""))
	if action_id.is_empty():
		_failures.append("%s profile is missing id" % label)
		return
	if action_id in _checked_ids:
		return
	_checked_ids.append(action_id)

	_hitbox.activate_for_profile(profile)
	var event: Dictionary = _hitbox.get_current_attack_event()
	var stagger_level: int = int(profile.get("stagger_level", _hitbox.base_stagger_level))
	var expected_poise: int = maxi(1, int(profile.get("poise_damage", stagger_level + 1)))
	var event_poise: int = int(event.get("poise_damage", 0))
	var metadata_poise: int = int(_hitbox.get_meta("poise_damage", 0))

	if event_poise != expected_poise:
		_failures.append("%s (%s) event poise_damage=%d expected=%d" % [label, action_id, event_poise, expected_poise])
	if metadata_poise != expected_poise:
		_failures.append("%s (%s) hitbox metadata poise_damage=%d expected=%d" % [label, action_id, metadata_poise, expected_poise])
	if int(event.get("stagger_level", -99)) != stagger_level:
		_failures.append("%s (%s) legacy stagger_level changed during canonical poise migration" % [label, action_id])


func _validate_enemy_runtime_prefers_canonical_poise() -> void:
	var runtime_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if not (runtime_value is EnemyCombatResponseRuntime):
		_failures.append("could not create EnemyCombatResponseRuntime fixture")
		return
	var runtime: EnemyCombatResponseRuntime = runtime_value as EnemyCombatResponseRuntime
	add_child(runtime)
	runtime.configure(null, EnemyCombatResponseProfile.warden_v2())

	var source := Area2D.new()
	add_child(source)

	# Canonical metadata must win even when legacy stagger metadata disagrees.
	source.set_meta("poise_damage", 1)
	source.set_meta("stagger_level", 9)
	if runtime.incoming_poise_power(source, {}) != 1:
		_failures.append("enemy response ignored canonical poise_damage=1 in favor of legacy stagger_level")

	source.set_meta("poise_damage", 2)
	source.set_meta("stagger_level", 0)
	if runtime.incoming_poise_power(source, {}) != 2:
		_failures.append("enemy response ignored canonical poise_damage=2 in favor of legacy stagger_level")

	# Non-migrated attack sources retain the compatibility bridge during convergence.
	source.remove_meta("poise_damage")
	source.set_meta("stagger_level", 1)
	if runtime.incoming_poise_power(source, {}) != 2:
		_failures.append("legacy non-sword stagger fallback no longer maps level 1 to poise power 2")

	source.queue_free()
	runtime.queue_free()


func _finish() -> void:
	if not _failures.is_empty():
		for failure: String in _failures:
			push_error("[CanonicalPoisePressureSmoke] %s" % failure)
		print("[CanonicalPoisePressureSmoke] FAIL - %d issue(s)" % _failures.size())
		get_tree().quit(1)
		return

	print("[CanonicalPoisePressureSmoke] PASS - %d player actions publish canonical poise pressure and enemy response prefers it" % _checked_ids.size())
	get_tree().quit(0)
