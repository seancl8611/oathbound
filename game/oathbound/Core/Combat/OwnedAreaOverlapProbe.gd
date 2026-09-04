extends Timer
class_name OwnedAreaOverlapProbe

## Emits the same deferred overlap signals used by bespoke boss hitboxes without
## leaving a SceneTreeTimer lambda alive after the temporary Area2D is freed.
## The probe is always parented to its Area2D; freeing the area also frees/cancels
## this timer before its callback can touch the dead object.


func arm(delay_seconds: float = 0.05) -> void:
	one_shot = true
	wait_time = maxf(0.001, delay_seconds)
	timeout.connect(_emit_current_overlaps)
	start()


func _emit_current_overlaps() -> void:
	var area := get_parent() as Area2D
	if area != null and is_instance_valid(area):
		for body in area.get_overlapping_bodies():
			area.body_entered.emit(body)
		for overlap_area in area.get_overlapping_areas():
			area.area_entered.emit(overlap_area)
	queue_free()
