extends Node2D

## Integration shell for the approved true-final / postgame Heart continuation.
## TRUE_FINAL_HEART.md explicitly defers attacks, movement, posture tuning, phase
## transition rules, arena details, and exact combat numbers. This shell therefore
## establishes only the already-approved two-phase encounter boundary and completion
## signal without fabricating a moveset that paper design has not approved.

signal heart_defeated(postgame_suppression: bool)

@onready var status_label: Label = get_node_or_null("StatusLabel") as Label

var postgame_suppression: bool = false
var _completed := false


func _ready() -> void:
	postgame_suppression = bool(get_meta("postgame_suppression", false))
	add_to_group("heart_encounter_shell")
	if status_label != null:
		status_label.text = "Heart Suppression" if postgame_suppression else "The Unbound Heart"
	print("[HeartEncounterShell] active mode=%s phases=2 combat_moveset=deferred" % ["suppression" if postgame_suppression else "true_final"])


func notify_heart_defeated() -> void:
	# Future authored Heart combat calls this once its second conceptual phase resolves.
	if _completed:
		return
	_completed = true
	heart_defeated.emit(postgame_suppression)


func complete_for_contract_test() -> void:
	# Headless contract tests can drive the completion handoff without pretending this
	# is a player-facing kill path. Normal gameplay has no input or gate wired here.
	if not bool(get_meta("contract_test", false)):
		push_warning("[HeartEncounterShell] contract completion rejected outside test mode")
		return
	notify_heart_defeated()
