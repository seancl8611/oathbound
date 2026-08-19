extends ColorRect

@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblLevel = $lbl_level
@onready var itemIcon: TextureRect = $ColorRect/ItemIcon

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	# Connect once to the player's upgrade handler
	if player and not is_connected("selected_upgrade", Callable(player, "upgrade_character")):
		connect("selected_upgrade", Callable(player, "upgrade_character"))

	# Fallback item key
	if item == null:
		item = "food"

	# Lookup with safe defaults
	var data: Dictionary = UpgradeDb.UPGRADES.get(item, {})
	var displayname: String = str(data.get("displayname", item))
	var details: String = str(data.get("details", ""))
	var level_text: String = str(data.get("level", "Level: 1"))
	var icon_path: String = str(data.get("icon", ""))

	# Populate labels
	lblName.text = displayname
	lblDescription.text = details
	lblLevel.text = level_text

	# Apply icon and clamp its visual size inside a fixed box
	var tex: Texture2D = null
	if icon_path != "":
		tex = load(icon_path)

	if itemIcon:
		var max_side: float = 48.0
		itemIcon.custom_minimum_size = Vector2(max_side, max_side)
		itemIcon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		itemIcon.texture = tex

		# Ensure the holder clips anything that might overflow
		var holder: ColorRect = $ColorRect
		if holder:
			holder.clip_contents = true

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade",item)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
