extends "res://Core/Corruption/OathboundCorruptionRuntime.gd"

## Release integration for failed-run / first-return records. The underlying Corruption
## authority still owns awakening and Corruption reset; this adapter closes the active
## run before those persistent state transitions occur.


func on_player_death() -> void:
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("on_run_finished") and RecordsRuntime.is_run_active():
		var result_kind := "first_return" if not is_awakened() else "failed"
		RecordsRuntime.on_run_finished(false, result_kind)
	super.on_player_death()
