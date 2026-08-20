extends RoomBase
class_name BossRoom

@onready var exit_gate: Node = $"ExitGate"
var _gate_unlocked = false
var _advanced = false
var _boss: Node = null

func _ready() -> void:
	if exit_gate and exit_gate.has_method("lock"):
		exit_gate.call_deferred("lock")

	if exit_gate and exit_gate.has_signal("gate_used"):
		if not exit_gate.is_connected("gate_used", Callable(self, "_on_exit_gate_used")):
			exit_gate.connect("gate_used", Callable(self, "_on_exit_gate_used"))

	# Wait one frame so deferred calls from children _ready() complete
	# (e.g. AshenBoss adds its HP bar to current_scene via call_deferred)
	await get_tree().process_frame

	_select_area_boss()

func _select_area_boss() -> void:
	var area_id = get_meta("area_id") if has_meta("area_id") else 1

	var containers = []
	for child in get_children():
		if child.has_meta("boss_area"):
			containers.append(child)

	if containers.is_empty():
		push_warning("[BossRoom] No boss containers found!")
		_on_boss_defeated()
		return

	var selected_container = null
	for container in containers:
		var boss_area = int(container.get_meta("boss_area", 0))
		if boss_area == area_id:
			selected_container = container
			break

	if selected_container == null:
		push_warning("[BossRoom] No boss for area %d, using first available." % area_id)
		selected_container = containers[0]

	# Free non-selected containers AND their orphaned external UI
	for container in containers:
		if container != selected_container:
			_cleanup_container_ui(container)
			container.queue_free()

	# Find the actual boss node inside the surviving container
	_boss = null
	for child in selected_container.get_children():
		if child.is_in_group("boss"):
			_boss = child
			break
	if _boss == null:
		for child in selected_container.get_children():
			if child.is_in_group("miniboss"):
				_boss = child
				break
	if _boss == null:
		for child in selected_container.get_children():
			if child.has_signal("defeated"):
				_boss = child
				break

	if _boss == null:
		push_warning("[BossRoom] No boss node found inside container!")
		_on_boss_defeated()
		return

	if _boss.has_signal("defeated"):
		if not _boss.is_connected("defeated", Callable(self, "_on_boss_defeated")):
			_boss.connect("defeated", Callable(self, "_on_boss_defeated"))
	else:
		if not _boss.tree_exited.is_connected(Callable(self, "_on_boss_defeated")):
			_boss.tree_exited.connect(_on_boss_defeated)

func _cleanup_container_ui(container: Node) -> void:
	## Removes external UI that bosses may have added to current_scene or root.
	## Bosses like AshenBoss add _bars_container to current_scene via call_deferred,
	## so queue_free on the container alone leaves orphaned UI nodes.
	for child in container.get_children():
		# Clean _bars_container added to external parents
		if "_bars_container" in child and is_instance_valid(child._bars_container):
			child._bars_container.queue_free()
		# Clean _currency_hud or other root-level UI
		if "_currency_hud" in child and is_instance_valid(child._currency_hud):
			child._currency_hud.queue_free()

func _on_boss_defeated() -> void:
	if _gate_unlocked:
		return
	_gate_unlocked = true
	if exit_gate and exit_gate.has_method("unlock"):
		exit_gate.call_deferred("unlock")

func _on_exit_gate_used(_gate_type: String) -> void:
	if _advanced:
		return
	_advanced = true
	emit_signal("room_cleared")
