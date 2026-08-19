extends RoomBase
class_name TreasureRoom

const TREASURE_REWARDS = {
	"gold":        {1: 120, 2: 160, 3: 200},
	"mist":        {1: 10,  2: 12,  3: 15},
	"scroll":      {1: 3,   2: 4,   3: 5},
	"maxhp":       {1: 5,   2: 7,   3: 10},
	"maxposture":  {1: 8,   2: 12,  3: 15},
}

# =============================================================================
# MINIBOSS POOLS
# =============================================================================

@export_group("Miniboss Pools")
@export var area_1_minibosses: Array[PackedScene] = []
@export var area_2_minibosses: Array[PackedScene] = []
@export var area_3_minibosses: Array[PackedScene] = []

@export_group("Miniboss Spawn")
@export var miniboss_spawn_point_path: NodePath = NodePath("MinibossSpawnPoint")
@export var miniboss_parent_path: NodePath = NodePath("")
@export var require_miniboss_to_unlock_chests: bool = true

# =============================================================================
# RUNTIME STATE
# =============================================================================

var _has_treasure_key: bool = false
var _treasure_key_consumed: bool = false
var _reward_claimed: bool = false
var _resolved: bool = false

var _treasure_chests: Array[Node] = []

var miniboss: Node = null
var _miniboss_defeated: bool = false
var _miniboss_spawned: bool = false

@onready var exit_gate: Node = get_node_or_null("ExitGate")


func _ready() -> void:
	add_to_group("treasure_room")
	
	lock_all_gates()
	
	await get_tree().process_frame
	
	_spawn_area_miniboss()
	_setup_treasure_chests()
	
	# If this room intentionally has no miniboss, allow chest access.
	# Normal treasure rooms should keep require_miniboss_to_unlock_chests = true.
	if miniboss == null and not require_miniboss_to_unlock_chests:
		_on_miniboss_defeated()


func _physics_process(_delta: float) -> void:
	_try_open_exit_gate()


# =============================================================================
# AREA / MINIBOSS SELECTION
# =============================================================================

func _get_area_id() -> int:
	if has_meta("area_id"):
		return int(get_meta("area_id"))
	
	var rd = get_node_or_null("/root/RunData")
	if rd:
		var v = rd.get("current_area_id")
		if v != null:
			return int(v)
	
	return 1


func _get_miniboss_pool_for_area(area_id: int) -> Array[PackedScene]:
	match area_id:
		1:
			return area_1_minibosses
		2:
			return area_2_minibosses
		3:
			return area_3_minibosses
		_:
			return area_1_minibosses


func _spawn_area_miniboss() -> void:
	var area_id := _get_area_id()
	var pool := _get_miniboss_pool_for_area(area_id)
	
	if pool.is_empty():
		push_warning("[TreasureRoom] No miniboss scenes assigned for area %d." % area_id)
		miniboss = null
		_miniboss_spawned = false
		return
	
	var valid_pool: Array[PackedScene] = []
	for scene in pool:
		if scene != null:
			valid_pool.append(scene)
	
	if valid_pool.is_empty():
		push_warning("[TreasureRoom] Area %d miniboss pool only contains null scenes." % area_id)
		miniboss = null
		_miniboss_spawned = false
		return
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var selected_scene: PackedScene = valid_pool[rng.randi_range(0, valid_pool.size() - 1)]
	var instance := selected_scene.instantiate()
	
	if instance == null:
		push_warning("[TreasureRoom] Failed to instantiate selected miniboss for area %d." % area_id)
		miniboss = null
		_miniboss_spawned = false
		return
	
	miniboss = instance
	_miniboss_spawned = true
	_miniboss_defeated = false
	
	var parent := _get_miniboss_parent()
	parent.add_child(miniboss)
	
	if miniboss is Node2D:
		(miniboss as Node2D).global_position = _get_miniboss_spawn_position()
	
	_prepare_miniboss_metadata(miniboss, area_id)
	_connect_miniboss(miniboss)
	
	print("[TreasureRoom] Spawned area %d miniboss: %s" % [area_id, miniboss.name])


func _get_miniboss_parent() -> Node:
	if miniboss_parent_path != NodePath(""):
		var p := get_node_or_null(miniboss_parent_path)
		if p:
			return p
	
	return self


func _get_miniboss_spawn_position() -> Vector2:
	var marker := get_node_or_null(miniboss_spawn_point_path)
	if marker and marker is Node2D:
		return (marker as Node2D).global_position
	
	var fallback := get_node_or_null("RoomCenter")
	if fallback and fallback is Node2D:
		return (fallback as Node2D).global_position
	
	return global_position


func _prepare_miniboss_metadata(enemy: Node, area_id: int) -> void:
	if not enemy.is_in_group("miniboss"):
		enemy.add_to_group("miniboss")
	
	enemy.set_meta("boss_area", area_id)
	enemy.set_meta("treasure_room_miniboss", true)
	enemy.set_meta("treasure_room", self)


func _connect_miniboss(enemy: Node) -> void:
	if enemy == null:
		return
	
	if enemy.has_signal("enemy_died"):
		var cb := Callable(self, "_on_miniboss_enemy_died")
		if not enemy.is_connected("enemy_died", cb):
			enemy.connect("enemy_died", cb)
	
	if enemy.has_signal("defeated"):
		var cb2 := Callable(self, "_on_miniboss_defeated")
		if not enemy.is_connected("defeated", cb2):
			enemy.connect("defeated", cb2)
	
	# Temporary compatibility with older scripts only.
	if enemy.has_signal("died"):
		var cb3 := Callable(self, "_on_miniboss_defeated")
		if not enemy.is_connected("died", cb3):
			enemy.connect("died", cb3)


func _on_miniboss_enemy_died(dead_enemy: Node) -> void:
	if miniboss != null and dead_enemy != miniboss:
		return
	
	_on_miniboss_defeated()


func _on_miniboss_defeated() -> void:
	if _miniboss_defeated:
		return
	
	_miniboss_defeated = true
	_has_treasure_key = true
	
	for chest in _treasure_chests:
		if chest == null or not is_instance_valid(chest):
			continue
		
		if chest.has_method("on_treasure_key_obtained"):
			chest.call("on_treasure_key_obtained")
		elif chest.has_method("unlock"):
			chest.call("unlock")
	
	print("[TreasureRoom] Miniboss defeated. Treasure key obtained.")


# =============================================================================
# CHEST SETUP
# =============================================================================

func _setup_treasure_chests() -> void:
	_treasure_chests.clear()
	
	var chests := get_tree().get_nodes_in_group("treasure_chest")
	for chest in chests:
		if chest != null and is_instance_valid(chest) and is_ancestor_of(chest):
			if not _treasure_chests.has(chest):
				_treasure_chests.append(chest)
	
	for chest in _treasure_chests:
		if chest == null or not is_instance_valid(chest):
			continue
		
		if chest.has_signal("chest_opened"):
			var cb := Callable(self, "_on_chest_opened")
			if not chest.is_connected("chest_opened", cb):
				chest.connect("chest_opened", cb)
		
		# Make sure chests start locked until the miniboss dies.
		if require_miniboss_to_unlock_chests and not _miniboss_defeated:
			if chest.has_method("lock"):
				chest.call("lock", true)


func _on_chest_opened(opened_chest: Node) -> void:
	if _reward_claimed:
		return
	
	_reward_claimed = true
	
	for chest in _treasure_chests:
		if chest == null or not is_instance_valid(chest):
			continue
		
		if chest == opened_chest:
			continue
		
		if chest.has_method("permanent_lock"):
			chest.call("permanent_lock")
		elif chest.has_method("lock"):
			chest.call("lock", true)
	
	_grant_treasure_reward()
	_try_open_exit_gate()


# =============================================================================
# REWARD
# =============================================================================

func _grant_treasure_reward() -> void:
	var reward_key = get_meta("reward_key") if has_meta("reward_key") else ""
	var area_id := _get_area_id()
	
	var amount := 0
	
	if reward_key != "boon" and reward_key != "":
		var table = TREASURE_REWARDS.get(reward_key, {})
		amount = table.get(area_id, table.get(1, 0))
	
	if reward_key == "":
		reward_key = "boon"
	
	var spawn_pos := global_position
	
	for chest in _treasure_chests:
		if chest != null and is_instance_valid(chest) and chest is Node2D:
			spawn_pos = (chest as Node2D).global_position + Vector2(0, -20)
			break
	
	var RewardPickupScript = load("res://Objects/RewardPickup.gd")
	if RewardPickupScript == null:
		push_warning("[TreasureRoom] RewardPickup.gd could not be loaded.")
		return
	
	var pickup = RewardPickupScript.new()
	
	if pickup.has_method("setup"):
		pickup.setup(reward_key, amount, area_id)
	
	if pickup is Node2D:
		(pickup as Node2D).global_position = spawn_pos
	
	add_child(pickup)
	
	print("[TreasureRoom] Reward pickup spawned: %s x%d" % [reward_key, amount])


# =============================================================================
# EXIT / ROOM CLEAR
# =============================================================================

func _try_open_exit_gate() -> void:
	if _resolved:
		return
	
	if not _reward_claimed:
		return
	
	if not _are_room_enemies_cleared():
		return
	
	_resolved = true
	_open_exit_gate()


func _are_room_enemies_cleared() -> bool:
	for n in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(n) or not n.is_inside_tree():
			continue
		
		if is_ancestor_of(n):
			return false
	
	return true


func _open_exit_gate() -> void:
	unlock_all_gates()


# =============================================================================
# TREASURE KEY API — used by TreasureChest
# =============================================================================

func has_treasure_key() -> bool:
	return _has_treasure_key and not _treasure_key_consumed


func try_consume_treasure_key() -> bool:
	if not has_treasure_key():
		return false
	
	_treasure_key_consumed = true
	return true
