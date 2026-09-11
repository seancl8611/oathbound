extends Node
class_name CombatActionRunner

## Shared Combat V2 action lifecycle.
##
## During the Swordsman migration this runner wraps the existing authored attack
## coroutines rather than replacing their canonical hitbox/damage path. It becomes the
## authoritative source for commitment and motion permissions immediately, while legacy
## attack code still announces ACTIVE / RECOVERY / COMPLETE transitions.

enum Phase {
	IDLE,
	STARTUP,
	COMMITTED,
	ACTIVE,
	RECOVERY,
}

signal action_started(action_id: StringName)
signal phase_changed(action_id: StringName, phase: int)
signal action_completed(action_id: StringName)
signal action_interrupted(action_id: StringName, reason: String)

var actor: Node = null
var definition: CombatActionDefinition = null
var phase: int = Phase.IDLE
var action_elapsed: float = 0.0
var phase_elapsed: float = 0.0


func configure(owner_actor: Node) -> void:
	actor = owner_actor


func begin(action_definition: CombatActionDefinition) -> void:
	if action_definition == null:
		return
	if phase != Phase.IDLE:
		interrupt("replaced")
	definition = action_definition
	action_elapsed = 0.0
	phase_elapsed = 0.0
	phase = Phase.STARTUP
	action_started.emit(definition.action_id)
	phase_changed.emit(definition.action_id, phase)
	_record("combat_v2_action_started", {
		"action_id": str(definition.action_id),
		"startup_duration": definition.startup_duration,
		"commit_fraction": definition.commit_fraction,
	})


func tick(delta: float) -> void:
	if phase == Phase.IDLE or definition == null:
		return
	var step: float = maxf(0.0, delta)
	action_elapsed += step
	phase_elapsed += step

	# Legacy attack coroutines still decide when ACTIVE begins in this migration slice.
	# The runner independently owns the commitment point inside startup so early windup
	# remains interruptible/tracking while late windup becomes committed and aim-locked.
	if phase == Phase.STARTUP and action_elapsed >= definition.sanitized_commit_time():
		_set_phase(Phase.COMMITTED)


func mark_active() -> void:
	if definition == null or phase == Phase.IDLE:
		return
	_set_phase(Phase.ACTIVE)


func mark_recovery() -> void:
	if definition == null or phase == Phase.IDLE:
		return
	if phase != Phase.RECOVERY:
		_set_phase(Phase.RECOVERY)


func complete() -> void:
	if definition == null or phase == Phase.IDLE:
		return
	var completed_id: StringName = definition.action_id
	_record("combat_v2_action_completed", {
		"action_id": str(completed_id),
		"elapsed": action_elapsed,
	})
	phase = Phase.IDLE
	definition = null
	action_elapsed = 0.0
	phase_elapsed = 0.0
	action_completed.emit(completed_id)


func interrupt(reason: String = "interrupted") -> void:
	if definition == null or phase == Phase.IDLE:
		return
	var interrupted_id: StringName = definition.action_id
	_record("combat_v2_action_interrupted", {
		"action_id": str(interrupted_id),
		"reason": reason,
		"phase": phase_name(),
		"elapsed": action_elapsed,
	})
	phase = Phase.IDLE
	definition = null
	action_elapsed = 0.0
	phase_elapsed = 0.0
	action_interrupted.emit(interrupted_id, reason)


func is_running() -> bool:
	return phase != Phase.IDLE and definition != null


func is_committed() -> bool:
	return phase in [Phase.COMMITTED, Phase.ACTIVE, Phase.RECOVERY]


func allows_target_tracking() -> bool:
	return phase == Phase.STARTUP


func locomotion_weight() -> float:
	if definition == null:
		return 1.0
	match phase:
		Phase.STARTUP:
			return clampf(definition.startup_locomotion_weight, 0.0, 1.0)
		Phase.COMMITTED:
			return clampf(definition.committed_locomotion_weight, 0.0, 1.0)
		Phase.ACTIVE:
			return clampf(definition.active_locomotion_weight, 0.0, 1.0)
		Phase.RECOVERY:
			return clampf(definition.recovery_locomotion_weight, 0.0, 1.0)
		_:
			return 1.0


func phase_progress() -> float:
	if definition == null:
		return 0.0
	match phase:
		Phase.STARTUP, Phase.COMMITTED:
			return clampf(action_elapsed / maxf(0.01, definition.startup_duration), 0.0, 1.0)
		Phase.ACTIVE:
			return clampf(phase_elapsed / maxf(0.01, definition.active_duration), 0.0, 1.0)
		Phase.RECOVERY:
			if definition.recovery_duration <= 0.0:
				return 1.0
			return clampf(phase_elapsed / definition.recovery_duration, 0.0, 1.0)
		_:
			return 0.0


func current_action_id() -> StringName:
	return definition.action_id if definition != null else &""


func phase_name() -> String:
	match phase:
		Phase.STARTUP:
			return "STARTUP"
		Phase.COMMITTED:
			return "COMMITTED"
		Phase.ACTIVE:
			return "ACTIVE"
		Phase.RECOVERY:
			return "RECOVERY"
		_:
			return "IDLE"


func _set_phase(new_phase: int) -> void:
	if phase == new_phase:
		return
	phase = new_phase
	phase_elapsed = 0.0
	var action_id: StringName = current_action_id()
	phase_changed.emit(action_id, phase)
	_record("combat_v2_action_phase", {
		"action_id": str(action_id),
		"phase": phase_name(),
		"action_elapsed": action_elapsed,
	})


func _record(event_name: String, extra: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if actor != null and is_instance_valid(actor):
		payload["actor"] = CombatTelemetry.snapshot_actor(actor)
	CombatTelemetry.record_event(event_name, payload)
