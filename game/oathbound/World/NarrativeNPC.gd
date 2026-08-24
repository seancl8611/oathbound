extends Area2D

## Lightweight Strand narrative interaction. Kept independent of the legacy station
## inheritance chain so NPC dialogue cannot interfere with Forge/Well/merchant menus.

@export var npc_id: String = "keeper"
@export var display_name: String = "Keeper"

const DIALOGUE_OVERLAY := preload("res://GUI/OathboundDialogueOverlay.tscn")

var _player_inside := false
var _dialogue_open := false
@onready var _popup: Label = get_node_or_null("InteractPopup") as Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if _popup != null:
		_popup.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and not _dialogue_open and event.is_action_pressed("interact"):
		_open_dialogue()
		get_viewport().set_input_as_handled()


func _on_body_entered(body: Node) -> void:
	if not _is_player(body):
		return
	_player_inside = true
	if _popup != null:
		_popup.visible = true


func _on_body_exited(body: Node) -> void:
	if not _is_player(body):
		return
	_player_inside = false
	if _popup != null:
		_popup.visible = false


func _open_dialogue() -> void:
	if NarrativeRuntime == null:
		return
	NarrativeRuntime.unlock_lore_for_campaign_state()
	var entry: Dictionary = NarrativeRuntime.get_next_strand_conversation(npc_id)
	if entry.is_empty():
		entry = _fallback_entry()
	if entry.is_empty():
		return
	entry["speaker"] = display_name
	if npc_id == "raven" and bool(entry.get("notice", false)):
		entry["speaker"] = "ORDER NOTICE"
	var overlay := DIALOGUE_OVERLAY.instantiate()
	var ui_layer := get_tree().current_scene.get_node_or_null("UILayer")
	if ui_layer == null:
		push_error("[NarrativeNPC] Hub UILayer missing")
		overlay.queue_free()
		return
	_dialogue_open = true
	ui_layer.add_child(overlay)
	overlay.sequence_finished.connect(_on_sequence_finished)
	overlay.tree_exited.connect(_on_overlay_exited)
	overlay.call("present", entry)


func _fallback_entry() -> Dictionary:
	var event_id := "story_complete" if MetaProgress.is_story_complete() else "failed_late"
	if npc_id == "raven" and not MetaProgress.is_story_complete():
		event_id = "failed_run"
	var reaction: Dictionary = NarrativeRuntime.get_reactive_lines(npc_id, event_id)
	if not reaction.is_empty():
		return reaction
	return {
		"id": "quiet_" + npc_id,
		"npc": npc_id,
		"speaker": display_name,
		"lines": ["There is nothing new to add before the next crossing."],
	}


func _on_sequence_finished(sequence_id: String) -> void:
	if not sequence_id.begins_with("quiet_"):
		NarrativeRuntime.mark_conversation_seen(sequence_id)
	_dialogue_open = false


func _on_overlay_exited() -> void:
	_dialogue_open = false


func _is_player(body: Node) -> bool:
	return body != null and (body.is_in_group("player") or body.name == "Player")
