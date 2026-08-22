extends Node

## Headless contract smoke for the approved Corruption/Shrine state machine.
## This runs only through CI/direct scene launch and uses the runner's disposable user dir.

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	_run_contract()
	if _failures.is_empty():
		print("[CorruptionRuntimeSmoke] PASS - caps awakening support Resist Embrace Stabilize")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[CorruptionRuntimeSmoke] %s" % failure)
		print("[CorruptionRuntimeSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_contract() -> void:
	if typeof(CorruptionRuntime) != TYPE_OBJECT:
		_fail("CorruptionRuntime autoload missing")
		return
	if typeof(MetaProgress) != TYPE_OBJECT:
		_fail("MetaProgress autoload missing")
		return
	if typeof(AspectRuntime) != TYPE_OBJECT:
		_fail("AspectRuntime autoload missing")
		return

	# Explicitly force the disposable runner into the first-attempt state so this test
	# does not depend on any user save that might exist during a local direct launch.
	MetaProgress.returning_blood_awakened = false
	if AspectRuntime.has_method("synchronize_campaign_state"):
		AspectRuntime.synchronize_campaign_state(false)
	CorruptionRuntime.on_new_run(1)
	_expect(not bool(CorruptionRuntime.call("is_awakened")), "first attempt must begin pre-awakening")
	_expect(str(CorruptionRuntime.call("get_corruption_state")) == "hidden", "pre-awakening Corruption state must be hidden")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 0, "new run must begin at 0 Corruption")

	# The first genuine death awakens Returning Blood and resets run pressure. Awakening
	# unlocks Aspect selection but does not silently choose a weapon kit for the player.
	CorruptionRuntime.set_corruption_for_playtest(67)
	CorruptionRuntime.on_player_death()
	_expect(bool(CorruptionRuntime.call("is_awakened")), "first death must awaken Returning Blood")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 0, "death must reset Corruption to 0")
	if AspectRuntime.has_method("has_active_aspect"):
		_expect(not bool(AspectRuntime.has_active_aspect()), "first death must wait for explicit Aspect selection")
	_expect(bool(AspectRuntime.select_aspect("wolf")), "awakened test run must allow explicit Wolf selection")

	# Successful parries are +1 with at most four points per chamber.
	CorruptionRuntime.on_room_entered("combat:technique")
	var parry_awarded: int = 0
	for _i: int in range(5):
		parry_awarded += int(CorruptionRuntime.on_successful_parry())
	_expect(parry_awarded == 4, "five successful parries must award only 4 Corruption in one chamber")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 4, "parry cap should leave total at 4")

	# Full threshold clamps at 100 and rejects further gain until Shrine resolution.
	CorruptionRuntime.on_room_entered("combat:gold")
	CorruptionRuntime.set_corruption_for_playtest(99)
	_expect(int(CorruptionRuntime.on_successful_parry()) == 1, "99 + successful parry must award exactly 1")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 100, "Corruption must clamp at 100")
	_expect(bool(CorruptionRuntime.call("is_shrine_ready")), "100 Corruption must be Shrine-ready")
	_expect(int(CorruptionRuntime.on_successful_parry()) == 0, "full Corruption must discard further gain")

	# Embrace advances exactly one Tier and empties Corruption.
	AspectRuntime.set_tier(0)
	var embrace: Dictionary = CorruptionRuntime.resolve_shrine("embrace", null)
	_expect(bool(embrace.get("success", false)), "Embrace should resolve at full Corruption below Tier IV")
	_expect(int(AspectRuntime.tier) == 1, "Embrace must advance exactly one Tier")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 0, "Embrace must set Corruption to 0")

	# Resist keeps Tier, returns to 75, and is valid regardless of already-full resources.
	CorruptionRuntime.set_corruption_for_playtest(100)
	var tier_before_resist: int = int(AspectRuntime.tier)
	var resist: Dictionary = CorruptionRuntime.resolve_shrine("resist", null)
	_expect(bool(resist.get("success", false)), "Resist should resolve at full Corruption")
	_expect(int(AspectRuntime.tier) == tier_before_resist, "Resist must keep the current Tier")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 75, "Resist must set Corruption to 75")

	# Below-full Shrine support leaves Corruption and Tier unchanged.
	CorruptionRuntime.set_corruption_for_playtest(40)
	var tier_before_support: int = int(AspectRuntime.tier)
	var support: Dictionary = CorruptionRuntime.resolve_shrine("support", null)
	_expect(bool(support.get("success", false)), "below-full support should resolve")
	_expect(int(AspectRuntime.tier) == tier_before_support, "support must not alter Tier")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 40, "support must not alter Corruption")

	# Tier IV has no Tier V; Stabilize returns pressure to 50 and keeps Tier IV.
	AspectRuntime.set_tier(4)
	CorruptionRuntime.set_corruption_for_playtest(100)
	_expect(str(CorruptionRuntime.call("get_shrine_state")) == "stabilize", "Tier IV + full must expose Stabilize")
	var stabilize: Dictionary = CorruptionRuntime.resolve_shrine("stabilize", null)
	_expect(bool(stabilize.get("success", false)), "Stabilize should resolve at Tier IV + full")
	_expect(int(AspectRuntime.tier) == 4, "Stabilize must not create Tier V")
	_expect(int(CorruptionRuntime.call("get_corruption")) == 50, "Stabilize must set Corruption to 50")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
