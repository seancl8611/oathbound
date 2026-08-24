extends Node2D

## Specialized non-counted Heart approach / Binding handoff space.
## It deliberately contains no invented Heart attacks. The true-final encounter's
## combat design remains deferred by TRUE_FINAL_HEART.md; this chamber establishes the
## approved campaign boundary and preserves the active Player/build when continuation
## is required.

signal handoff_completed(outcome: String)

const ENDGAME_FLOW = preload("res://Core/Endgame/OathboundEndgameFlow.gd")

@onready var exit_gate: Node = get_node_or_null("ExitGate")
@onready var status_label: Label = get_node_or_null("StatusLabel") as Label

var outcome: String = ""
var _used := false


func _ready() -> void:
	outcome = str(get_meta("endgame_outcome", ""))
	_configure_presentation()
	if exit_gate != null and exit_gate.has_signal("gate_used"):
		var cb := Callable(self, "_on_gate_used")
		if not exit_gate.is_connected("gate_used", cb):
			exit_gate.connect("gate_used", cb)
	if exit_gate != null and exit_gate.has_method("unlock"):
		exit_gate.call_deferred("unlock")
	print("[HeartHandoff] active outcome=%s counted_chamber=false" % outcome)


func _configure_presentation() -> void:
	var headline := "Heart Approach"
	var gate_text := "Continue"
	match outcome:
		ENDGAME_FLOW.OUTCOME_BINDING_COMPLETION:
			headline = "Heart Binding Ritual"
			gate_text = "Break Binding"
			if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_heart_bindings_remaining"):
				var remaining := int(MetaProgress.call("get_heart_bindings_remaining"))
				headline += "\n%d of 6 Bindings remain" % remaining
		ENDGAME_FLOW.OUTCOME_PRE_AWAKENED_HEART_CONTACT:
			headline = "The Heart\nReturning Blood has not awakened"
			gate_text = "Approach"
		ENDGAME_FLOW.OUTCOME_TRUE_FINAL_HEART:
			headline = "The Unbound Heart\nAll six Bindings are destroyed"
			gate_text = "Face the Heart"
		ENDGAME_FLOW.OUTCOME_HEART_SUPPRESSION:
			headline = "Heart Suppression\nThe regenerating remnant awaits"
			gate_text = "Enter Suppression"
		_:
			headline = "Heart Approach"

	if status_label != null:
		status_label.text = headline
	var gate_label := exit_gate.get_node_or_null("Label") if exit_gate != null else null
	if gate_label is Label:
		(gate_label as Label).text = gate_text
	if exit_gate != null and exit_gate.has_method("set_indicator"):
		exit_gate.call("set_indicator", "Event")


func _on_gate_used(_gate_type: String) -> void:
	if _used:
		return
	_used = true
	if exit_gate != null and exit_gate.has_method("lock"):
		exit_gate.call("lock")
	handoff_completed.emit(outcome)
