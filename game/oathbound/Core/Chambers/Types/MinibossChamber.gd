extends "res://Core/Chambers/Types/MinibossChamberController.gd"

## Canonical miniboss-chamber rules layer.
## The imported TreasureRoom controller keeps scene/chest plumbing temporarily; this
## layer enforces the current premium Technique + persistent bonus contract for all
## three reconciled launch regions.

const MINIBOSS_PERSISTENT_MIST := 10
const MINIBOSS_PERSISTENT_SCROLLS := 1

# Stable completion/achievement IDs for the six authored launch minibosses. Scene paths
# are the authority here because runtime node names can be edited independently of
# persistent record keys. Unknown/debug minibosses must not inflate the six-target
# Named Threats achievement. Runtime-hardening wrappers intentionally map to the same
# persistent IDs as their authored source scenes.
const LAUNCH_MINIBOSS_SCENE_IDS := {
	"res://Regions/Hushiro/Enemies/Minibosses/VillageOgre.tscn": "village_ogre",
	"res://Regions/Hushiro/Enemies/Minibosses/TheCollector.tscn": "the_collector",
	"res://Enemy/Area 2/Minibosses/embered_pilgrim.tscn": "embered_pilgrim",
	"res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.tscn": "embered_pilgrim",
	"res://Enemy/Area 2/Minibosses/rotwood_host.tscn": "rotwood_host",
	"res://Enemy/Area 2/Minibosses/rotwood_host_runtime.tscn": "rotwood_host",
	"res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn": "blood_lotus",
	"res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn": "eternal_swordsman",
}
const LAUNCH_MINIBOSS_IDS: Array[String] = [
	"village_ogre",
	"the_collector",
	"embered_pilgrim",
	"rotwood_host",
	"blood_lotus",
	"eternal_swordsman",
]

var _persistent_bonus_granted := false


func _uses_current_miniboss_reward() -> bool:
	return _get_area_id() in [1, 2, 3]


func _setup_treasure_chests() -> void:
	super._setup_treasure_chests()
	if not _uses_current_miniboss_reward() or _treasure_chests.is_empty():
		return

	# Current minibosses have one premium primary reward, not three cosmetic chests
	# that all resolve through legacy reward keys. Keep the first chest only.
	var primary: Node = _treasure_chests[0]
	if "chest_category_name" in primary:
		primary.set("chest_category_name", "Technique Reward")
	var title := primary.get_node_or_null("Menu/Panel/Label")
	if title is Label:
		title.text = "Technique Reward"

	for i in range(1, _treasure_chests.size()):
		var extra: Node = _treasure_chests[i]
		if extra == null or not is_instance_valid(extra):
			continue
		if extra is CanvasItem:
			(extra as CanvasItem).visible = false
		extra.process_mode = Node.PROCESS_MODE_DISABLED
		var area := extra.get_node_or_null("Area2D")
		if area is Area2D:
			area.monitoring = false
			area.monitorable = false
		if extra.has_method("permanent_lock"):
			extra.call("permanent_lock")

	_treasure_chests = [primary]


func _on_miniboss_defeated() -> void:
	var first_resolution := not _miniboss_defeated
	var miniboss_id := _current_miniboss_record_id()
	super._on_miniboss_defeated()
	if not first_resolution or _persistent_bonus_granted:
		return

	_persistent_bonus_granted = true
	_record_miniboss_progress(miniboss_id)

	var rd := get_node_or_null("/root/RunData")
	if rd != null and rd.has_method("add_mist"):
		rd.add_mist(MINIBOSS_PERSISTENT_MIST)
		rd.add_scrolls(MINIBOSS_PERSISTENT_SCROLLS)
	else:
		MetaProgress.add_mist(MINIBOSS_PERSISTENT_MIST)
		MetaProgress.add_scrolls(MINIBOSS_PERSISTENT_SCROLLS)

	print("[MinibossChamber] Persistent bonus banked: +10 Mist / +1 Scroll | miniboss=%s" % miniboss_id)


func _record_miniboss_progress(miniboss_id: String) -> void:
	if miniboss_id not in LAUNCH_MINIBOSS_IDS:
		push_warning("[MinibossChamber] Defeated miniboss has no launch record ID; completion not credited: %s" % miniboss_id)
		return
	if typeof(AchievementRuntime) == TYPE_OBJECT and AchievementRuntime.has_method("record_miniboss_defeat"):
		AchievementRuntime.record_miniboss_defeat(miniboss_id)
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("record_miniboss_defeat"):
		RecordsRuntime.record_miniboss_defeat()


func _current_miniboss_record_id() -> String:
	if miniboss == null or not is_instance_valid(miniboss):
		return ""
	var scene_path := str(miniboss.scene_file_path)
	return str(LAUNCH_MINIBOSS_SCENE_IDS.get(scene_path, ""))


func _on_chest_opened(opened_chest: Node) -> void:
	if not _uses_current_miniboss_reward():
		super._on_chest_opened(opened_chest)
		return
	if _reward_claimed:
		return

	for chest in _treasure_chests:
		if chest == null or not is_instance_valid(chest) or chest == opened_chest:
			continue
		if chest.has_method("permanent_lock"):
			chest.call("permanent_lock")

	var pickup_script = load("res://Objects/RewardPickup.gd")
	if pickup_script == null:
		push_warning("[MinibossChamber] RewardPickup.gd could not be loaded.")
		return

	var pickup = pickup_script.new()
	pickup.setup("boon", 0, _get_area_id())
	pickup.set_meta("technique_source", UpgradeService.SOURCE_MINIBOSS)
	var spawn_pos := global_position
	if opened_chest is Node2D:
		spawn_pos = (opened_chest as Node2D).global_position + Vector2(0, -20)
	if pickup is Node2D:
		(pickup as Node2D).global_position = spawn_pos
	add_child(pickup)

	# Reward completion, not merely chest interaction, unlocks the route.
	await pickup.collected
	_reward_claimed = true
	_try_open_exit_gate()
	print("[MinibossChamber] Technique reward completed; exit unlocked")
