extends Node

const BILEMASS_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CellarBilemass.tscn")
const READABILITY_SCRIPT: GDScript = preload("res://Core/Combat/BilemassLandingReadability.gd")
const PASS_LINE := "[BilemassLandingReadabilitySmoke] PASS - full remaining landing timeline | light-medium-dark stages | spatial-only warning | cancel cleanup"
const TEST_DURATION: float = 0.45
const BOUNDARY_EPSILON: float = 0.0001

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var enemy: Node = BILEMASS_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate canonical Cellar Bilemass")
		_finish()
		return
	enemy.name = "LandingReadabilityBilemass"
	add_child(enemy)
	await get_tree().process_frame
	enemy.set_physics_process(false)

	var runtime: Node = enemy.get_node_or_null("BilemassLandingReadability")
	_expect(runtime != null, "canonical Bilemass scene is missing landing readability runtime")
	if runtime == null:
		enemy.queue_free()
		_finish()
		return

	# Canonical timing: the legacy marker is created AFTER the 0.30s windup. From that
	# moment, puddle landing still waits through 0.45s vomit + 3.0s travel = 3.45s.
	var canonical_duration: float = float(runtime.call("expected_warning_duration", enemy))
	_expect(is_equal_approx(canonical_duration, 3.45), "landing warning does not cover vomit + travel (expected 3.45s)")

	# Stage/deadline semantics are tested at exact elapsed-time boundaries rather than
	# sleeping for sub-second timers. CI frame scheduling must never decide whether a
	# presentation-contract test lands just before or just after one of these thresholds.
	_validate_timeline_boundaries(TEST_DURATION)

	# Keep one real runtime arming observation. A busy first process frame must still
	# expose LIGHT before any later stage is eligible.
	enemy.set("spit_vomit_duration", 0.18)
	enemy.set("spit_travel_time", 0.27)
	enemy.set("beast_is_attacking", true)
	enemy.set("_v2_hazard_launched", true)

	var target := Vector2(84.0, 42.0)
	var legacy := _make_legacy_indicator(target)
	enemy.set("_pending_spit_indicator", legacy)
	await get_tree().process_frame

	_expect(bool(runtime.call("has_active_warning")), "committed hazard did not create staged landing warning")
	_expect(is_equal_approx(float(runtime.call("active_warning_duration")), TEST_DURATION), "staged warning duration drifted from vomit + travel")
	_expect(str(runtime.call("active_stage_name")) == "light", "landing warning did not begin in light stage")
	_expect(not _legacy_visual_visible(legacy), "legacy early-expiring indicator remained visible under staged warning")

	var active_value: Variant = runtime.call("active_indicator_for_test")
	_expect(active_value is Node2D, "staged warning did not expose active spatial marker")
	if active_value is Node2D:
		var active: Node2D = active_value as Node2D
		_expect(active.global_position.distance_to(target) < 0.01, "staged warning moved away from authored landing target")
		_expect(str(active.get_meta("hazard_language", "")) == "ground_landing", "landing warning lost ground-hazard presentation classification")
		_expect(not bool(active.get_meta("parry_prompt", true)), "Bilemass ground hazard was incorrectly classified as a parry prompt")

	# A pre-landing cancellation must remove presentation on the next runtime frame.
	# This is cleanup only; the runtime never cancels or spawns the canonical hazard.
	enemy.set("beast_is_attacking", false)
	enemy.set("_v2_hazard_launched", false)
	await get_tree().process_frame
	_expect(not bool(runtime.call("has_active_warning")), "cancelled spit left a stale ground warning")

	# A later committed hazard must still be able to arm after cleanup and preserve the
	# same spatial/non-parry classification. This also proves `_last_pending_id` only
	# suppresses duplicate observation of the same canonical legacy marker.
	enemy.set("beast_is_attacking", true)
	enemy.set("_v2_hazard_launched", true)
	var cancel_target := Vector2(-60.0, 30.0)
	var legacy_cancel := _make_legacy_indicator(cancel_target)
	enemy.set("_pending_spit_indicator", legacy_cancel)
	await get_tree().process_frame
	_expect(bool(runtime.call("has_active_warning")), "second hazard warning did not arm")
	_expect(str(runtime.call("active_stage_name")) == "light", "second hazard warning did not restart at light stage")

	enemy.set("beast_is_attacking", false)
	enemy.set("_v2_hazard_launched", false)
	await get_tree().process_frame
	_expect(not bool(runtime.call("has_active_warning")), "second cancelled spit left a stale ground warning")

	legacy.queue_free()
	legacy_cancel.queue_free()
	enemy.queue_free()
	await get_tree().process_frame
	_finish()


func _validate_timeline_boundaries(duration: float) -> void:
	var medium_at: float = duration / 3.0
	var dark_at: float = duration * 2.0 / 3.0

	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(0.0, duration)) == "light", "timeline does not start in light stage")
	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(medium_at - BOUNDARY_EPSILON, duration)) == "light", "light stage ended before first-third boundary")
	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(medium_at, duration)) == "medium", "medium stage did not begin at first-third boundary")
	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(dark_at - BOUNDARY_EPSILON, duration)) == "medium", "medium stage ended before two-thirds boundary")
	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(dark_at, duration)) == "dark", "dark stage did not begin at two-thirds boundary")
	_expect(String(READABILITY_SCRIPT.stage_for_elapsed(duration - BOUNDARY_EPSILON, duration)) == "dark", "dark stage did not persist until landing deadline")

	_expect(not READABILITY_SCRIPT.landing_due_for_elapsed(duration - BOUNDARY_EPSILON, duration), "landing deadline fired early")
	_expect(READABILITY_SCRIPT.landing_due_for_elapsed(duration, duration), "landing deadline did not fire at exact arrival")
	_expect(READABILITY_SCRIPT.landing_due_for_elapsed(duration + BOUNDARY_EPSILON, duration), "landing deadline did not remain due after arrival")


func _make_legacy_indicator(target: Vector2) -> Node2D:
	var root := Node2D.new()
	root.name = "LegacyLandingIndicator"
	add_child(root)
	root.global_position = target
	var sprite := Sprite2D.new()
	sprite.name = "LegacyVisual"
	root.add_child(sprite)
	return root


func _legacy_visual_visible(root: Node2D) -> bool:
	for child: Node in root.get_children():
		if child is CanvasItem and (child as CanvasItem).visible:
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BilemassLandingReadabilitySmoke] " + failure)
	print("[BilemassLandingReadabilitySmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)
