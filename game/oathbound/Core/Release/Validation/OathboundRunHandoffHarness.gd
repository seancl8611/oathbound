extends "res://Core/Release/OathboundReleaseGameFlow.gd"

## Test-only seam around the production release GameFlow.
##
## The inherited _advance_to_next_area() method remains completely production-owned.
## We replace only presentation, safe-swap UI, and room scene loading so the headless
## integration smoke can exercise Region 1 -> 2 -> 3 state handoffs deterministically
## without pretending to be a full gameplay traversal.

var transition_areas: Array[int] = []
var relic_swap_contexts: Array[String] = []
var loaded_areas: Array[int] = []
var loaded_routes: Array[Array] = []


func _ready() -> void:
	# Suppress the production autoload ownership diagnostics for this second,
	# test-only GameFlow instance. The smoke separately asserts the real GameFlow
	# autoload is OathboundReleaseGameFlow.
	pass


func _offer_safe_relic_swap(context: String) -> void:
	relic_swap_contexts.append(context)
	await get_tree().process_frame


func _show_area_transition(area_id: int) -> void:
	transition_areas.append(area_id)
	await get_tree().process_frame


func _load_current_room() -> void:
	loaded_areas.append(current_area)
	loaded_routes.append(route.duplicate())
	await get_tree().process_frame
