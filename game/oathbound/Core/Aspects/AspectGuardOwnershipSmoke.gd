extends Node

## Combat V2 defense ownership contract.
##
## The pre-awakening base katana keeps the compatibility Guard while Blood Aspects are
## inactive. After an Aspect is selected, held/sustained Guard and its Reprisal handoff
## belong to Ronin. Wolf and Wraith retain the shared tap-parry window, but every legacy
## hold-to-block shortcut must stop at that window instead of settling into BLOCKING.

const CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const PLAYER_SCENE = preload("res://Player/aspect_player.tscn")

const STATE_IDLE := 0
const STATE_BLOCKING := 6
const STATE_PARRYING := 7
const PARRY_TEST_WINDOW := 0.12

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	await _run_contract()
	Input.action_release("parry")
	if _failures.is_empty():
		print("[AspectGuardOwnershipSmoke] PASS - base Guard retained; Wolf/Wraith tap-parry only; Ronin owns sustained Guard")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[AspectGuardOwnershipSmoke] %s" % failure)
		print("[AspectGuardOwnershipSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_contract() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT or typeof(AspectRuntime) != TYPE_OBJECT:
		_fail("required campaign/Aspect runtimes missing")
		return

	# Base-katana compatibility remains available before Returning Blood awakens.
	MetaProgress.returning_blood_awakened = false
	AspectRuntime.synchronize_campaign_state(false)
	var base_player: Node = await _spawn_player()
	if base_player != null:
		_expect(bool(base_player.call("allows_sustained_guard_for_test")), "base katana must retain sustained Guard compatibility")
		base_player.call("_start_block")
		_expect(_state_of(base_player) == STATE_BLOCKING, "base katana direct Guard must enter BLOCKING")
		base_player.call("_end_block")
		await _free_player(base_player)

	# Awaken once, then prove both non-Ronin Aspects reject every inherited route that
	# could otherwise recreate a universal held Guard.
	MetaProgress.returning_blood_awakened = true
	AspectRuntime.synchronize_campaign_state(false)
	await _verify_non_guard_aspect(CATALOG.WOLF, "Wolf")
	await _verify_non_guard_aspect(CATALOG.WRAITH, "Wraith")

	# Ronin is the positive ownership case: a held parry input opens the shared parry
	# window first and then settles into sustained Guard when that window expires.
	_expect(bool(AspectRuntime.select_aspect(CATALOG.RONIN)), "Ronin selection must succeed after awakening")
	var ronin: Node = await _spawn_player()
	if ronin != null:
		_expect(bool(ronin.call("allows_sustained_guard_for_test")), "Ronin must own sustained Guard")
		Input.action_press("parry")
		ronin.call("_start_parry", PARRY_TEST_WINDOW)
		_expect(_state_of(ronin) == STATE_PARRYING, "Ronin held defense must still open the shared parry window first")
		ronin.call("_state_parrying", PARRY_TEST_WINDOW + 0.01)
		_expect(_state_of(ronin) == STATE_BLOCKING, "Ronin held defense must enter BLOCKING after the parry window")
		Input.action_release("parry")
		ronin.call("_end_block")
		await _free_player(ronin)


func _verify_non_guard_aspect(aspect_id: String, label: String) -> void:
	_expect(bool(AspectRuntime.select_aspect(aspect_id)), "%s selection must succeed after awakening" % label)
	var player: Node = await _spawn_player()
	if player == null:
		return

	_expect(not bool(player.call("allows_sustained_guard_for_test")), "%s must not own sustained Guard" % label)

	Input.action_press("parry")
	player.call("_start_block")
	_expect(_state_of(player) != STATE_BLOCKING, "%s direct held Guard must not enter BLOCKING" % label)

	player.call("_start_parry", PARRY_TEST_WINDOW)
	_expect(_state_of(player) == STATE_PARRYING, "%s must retain the shared tap-parry window" % label)
	player.call("_state_parrying", PARRY_TEST_WINDOW + 0.01)
	_expect(_state_of(player) == STATE_IDLE, "%s held parry expiry must return to IDLE instead of BLOCKING" % label)

	player.set("_buffered_action", "parry")
	player.set("_buffer_timer", 0.10)
	player.call("_process_buffered_input")
	_expect(_state_of(player) == STATE_PARRYING, "%s buffered held defense must resolve to PARRYING, not BLOCKING" % label)
	player.call("_on_anim_finished", "parry")
	_expect(_state_of(player) == STATE_IDLE, "%s parry animation completion must not take over into BLOCKING" % label)

	Input.action_release("parry")
	await _free_player(player)


func _spawn_player() -> Node:
	var player: Node = PLAYER_SCENE.instantiate()
	add_child(player)
	await get_tree().process_frame
	if not player.has_method("allows_sustained_guard_for_test"):
		_fail("canonical Player is missing sustained-Guard ownership probe")
		await _free_player(player)
		return null
	return player


func _free_player(player: Node) -> void:
	if player != null and is_instance_valid(player):
		player.queue_free()
		await get_tree().process_frame


func _state_of(player: Node) -> int:
	return int(player.get("_state"))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
