extends HubInteractable

## Blood Mirror — permanent Blood Aspect progression mechanism inside Blood Cavern.
## The outer Cavern remains usable before the first Keeper defeat; the deeper Mirror
## stays dormant until that campaign gate and its menu owns the permanent node surface.

signal upgrade_purchased(upgrade_id: String)

const BLOOD_MIRROR_MENU := preload("res://GUI/BloodMirrorMenu.tscn")

var _menu: Control = null


func _on_ready_custom() -> void:
	_refresh_interaction_copy()


func _blood_mirror_unlocked() -> bool:
	return (
		typeof(MetaProgressionManager) == TYPE_OBJECT
		and MetaProgressionManager.has_method("is_blood_mirror_unlocked")
		and bool(MetaProgressionManager.call("is_blood_mirror_unlocked"))
	)


func is_blood_mirror_unlocked_for_playtest() -> bool:
	return _blood_mirror_unlocked()


func _refresh_interaction_copy() -> void:
	var popup: Label = get_node_or_null("InteractPopup") as Label
	if popup == null:
		return
	popup.text = "Blood Mirror [E]" if _blood_mirror_unlocked() else "Blood Mirror — Dormant"


func _open_menu() -> void:
	# The approved Blood Cavern state is physical dormancy before the first Keeper
	# defeat. Reject the interaction itself instead of opening a progression screen
	# whose purchase buttons happen to be disabled.
	if not _blood_mirror_unlocked():
		_refresh_interaction_copy()
		close_menu()
		print("[BloodMirror] Dormant — defeat the Keeper once to awaken the Mirror")
		return

	super._open_menu()
	if _menu != null and is_instance_valid(_menu):
		return
	_menu = BLOOD_MIRROR_MENU.instantiate()
	var current_scene: Node = get_tree().current_scene
	var ui_layer: Node = current_scene.get_node_or_null("UILayer") if current_scene != null else null
	if ui_layer == null:
		push_error("[BloodMirror] Hub UILayer missing")
		close_menu()
		return
	ui_layer.add_child(_menu)
	if _menu.has_signal("menu_closed"):
		_menu.menu_closed.connect(close_menu)
	if _menu.has_signal("upgrade_purchased"):
		_menu.upgrade_purchased.connect(_on_upgrade_purchased)
	_menu.tree_exited.connect(close_menu)


func _on_upgrade_purchased(upgrade_id: String) -> void:
	upgrade_purchased.emit(upgrade_id)
	print("[BloodMirror] Purchased Aspect progression: %s" % upgrade_id)


func _on_menu_closed_custom() -> void:
	_menu = null
