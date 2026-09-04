extends Node
class_name DuoBossManager

## =============================================================================
## SHELL DUO MANAGER — Coordinator for the reworked Shell Duo boss fight
## =============================================================================
## Each twin is a distinct threat (melee hunter vs ranged controller).
## Shell is a one-time 50% HP transition per twin with unique behavior.
## Manager prevents shell overlap and handles empowered survivor transition.
## =============================================================================

signal defeated
signal twin_died(who: Node)
signal special_mode_started(who: Node)
signal special_mode_ended(who: Node)

# Backward-compatible signal names, safe to keep while old scripts are being migrated.
signal shell_started(who: Node)
signal shell_ended(who: Node)

@export var twin_a_path: NodePath = ""
@export var twin_b_path: NodePath = ""

var _twin_a: Node = null
var _twin_b: Node = null
var _active_special_twin: Node = null
var _pending_special_twin: Node = null
var _twins_dead = 0


func _ready() -> void:
	# BossChamber contains all regional boss containers until it selects the current
	# area one frame later. Do not initialize the Area-2 duo manager while Keeper or
	# Eclipse Shogun is the active fight; that produced a false missing-twins warning
	# before the non-selected container was removed.
	if not _is_current_boss_area():
		return

	add_to_group("boss")

	if twin_a_path != NodePath(""):
		_twin_a = get_node_or_null(twin_a_path)
	if twin_b_path != NodePath(""):
		_twin_b = get_node_or_null(twin_b_path)

	# Fallback: find twins among siblings by group.
	if _twin_a == null or _twin_b == null:
		var twins = []
		for child in get_parent().get_children():
			if child.is_in_group("duo_boss_twin") \
			or child.is_in_group("briarthorn_duo_twin") \
			or child.is_in_group("rootfang_duo_twin") \
			or child.is_in_group("shell_duo_twin"):
				twins.append(child)

		if twins.size() >= 2:
			_twin_a = twins[0]
			_twin_b = twins[1]

	if _twin_a == null or _twin_b == null:
		push_warning("[ShellDuoManager] Could not find both twins!")
		return

	_twins_dead = 0
	_active_special_twin = null
	_pending_special_twin = null

	if _twin_a.has_method("set_manager"):
		_twin_a.set_manager(self)
	if _twin_b.has_method("set_manager"):
		_twin_b.set_manager(self)


func _is_current_boss_area() -> bool:
	var container: Node = get_parent()
	if container == null or not container.has_meta("boss_area"):
		return true
	if typeof(RunData) != TYPE_OBJECT:
		return true
	return int(container.get_meta("boss_area", 0)) == int(RunData.current_area_id)


## Called by a twin when it crosses 50% HP and wants to shell.
## Returns true if shell starts now, false if deferred.
func request_special_mode(who: Node) -> bool:
	# A stale special-mode owner should never block the surviving twin. The cached
	# twin references intentionally outlive phase transitions, so validate them at
	# every manager boundary rather than relying on truthiness alone.
	if not _is_alive(_active_special_twin):
		_active_special_twin = null

	if _active_special_twin == null:
		_active_special_twin = who
		emit_signal("special_mode_started", who)
		emit_signal("shell_started", who) # backward-compatible
		return true

	_pending_special_twin = who
	return false


func request_briarthorn(who: Node) -> bool:
	return request_special_mode(who)


func request_rootfang(who: Node) -> bool:
	return request_special_mode(who)


func request_shell(who: Node) -> bool:
	return request_special_mode(who)


## Called by a twin when its shell sequence finishes.
func notify_special_mode_ended(who: Node) -> void:
	if _active_special_twin == who:
		_active_special_twin = null

	emit_signal("special_mode_ended", who)
	emit_signal("shell_ended", who) # backward-compatible

	if _pending_special_twin == null:
		return

	# Keep this local untyped/Variant-safe. A cached Object can become freed between
	# frames, and passing such a value through a custom `Node`-typed function boundary
	# raises before `is_instance_valid()` gets a chance to reject it.
	var pending: Variant = _pending_special_twin
	_pending_special_twin = null

	if not _is_alive(pending):
		return

	_active_special_twin = pending as Node

	if pending.has_method("trigger_deferred_briarthorn"):
		pending.call_deferred("trigger_deferred_briarthorn")
	elif pending.has_method("trigger_deferred_rootfang"):
		pending.call_deferred("trigger_deferred_rootfang")
	elif pending.has_method("trigger_deferred_shell"):
		pending.call_deferred("trigger_deferred_shell")


func notify_briarthorn_ended(who: Node) -> void:
	notify_special_mode_ended(who)


func notify_rootfang_ended(who: Node) -> void:
	notify_special_mode_ended(who)


func notify_shell_ended(who: Node) -> void:
	notify_special_mode_ended(who)


func notify_died(who: Node) -> void:
	if _active_special_twin == who:
		_active_special_twin = null

	if _pending_special_twin == who:
		_pending_special_twin = null

	# Resolve the partner before forgetting the dead twin. The September 4 playtest
	# killed Rootfang first; by the time Briarthorn died, Rootfang's cached reference
	# was a previously-freed Object. `_is_alive(Node)` rejected that argument before
	# its validity guard ran. Keep stale-reference boundaries Variant-safe and clear
	# the dead cache immediately after the partner lookup.
	var partner: Variant = get_partner(who)
	_forget_twin(who)
	_twins_dead += 1

	if _is_alive(partner):
		if partner.has_method("on_partner_died"):
			partner.on_partner_died()

	emit_signal("twin_died", who)

	if _twins_dead >= 2:
		emit_signal("defeated")


func get_partner(who: Node) -> Variant:
	if who == _twin_a:
		return _twin_b
	elif who == _twin_b:
		return _twin_a
	return null


func is_partner_alive(who: Node) -> bool:
	return _is_alive(get_partner(who))


func is_anyone_in_special_mode() -> bool:
	if not _is_alive(_active_special_twin):
		_active_special_twin = null
	return _active_special_twin != null


func get_special_mode_twin() -> Variant:
	if not _is_alive(_active_special_twin):
		_active_special_twin = null
	return _active_special_twin


# Backward-compatible aliases.
func is_anyone_shelled() -> bool:
	return is_anyone_in_special_mode()


func get_shelled_twin() -> Variant:
	return get_special_mode_twin()


func _forget_twin(who: Node) -> void:
	if who == _twin_a:
		_twin_a = null
	elif who == _twin_b:
		_twin_b = null


func _is_alive(who: Variant) -> bool:
	if who == null:
		return false
	if not is_instance_valid(who):
		return false
	if not (who is Node):
		return false
	if who.has_method("is_dead"):
		return not bool(who.is_dead())
	return true
