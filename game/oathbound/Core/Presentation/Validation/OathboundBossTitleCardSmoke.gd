extends Node

const BOSS_TITLE_CARD = preload("res://Core/Presentation/OathboundBossTitleCard.gd")


func _ready() -> void:
	await get_tree().process_frame
	var old_high_contrast: Variant = SettingsManager.get_value("high_contrast", false)
	var old_text_scale: Variant = SettingsManager.get_value("text_scale", 1.0)
	SettingsManager.set_value("high_contrast", true)
	SettingsManager.set_value("text_scale", 1.5)
	await get_tree().process_frame

	var card_value: Variant = BOSS_TITLE_CARD.new()
	_assert(card_value is CanvasLayer, "boss title card must instantiate as CanvasLayer")
	var card: CanvasLayer = card_value as CanvasLayer
	card.set("auto_free_on_dismiss", false)
	get_tree().root.add_child(card)
	await get_tree().process_frame

	_assert(bool(card.call("present", 1)), "Keeper title should present")
	await get_tree().process_frame
	_assert_content(card, 1, "Keeper", "HUSHIRO VILLAGE")
	_assert(int(card.call("get_title_font_size_for_playtest")) >= 37, "text-scale setting not reflected in boss title")

	_assert(bool(card.call("present", 2)), "Twin Maws title should present")
	await get_tree().process_frame
	_assert_content(card, 2, "Twin Maws", "HUNTING GROUNDS")

	_assert(bool(card.call("present", 3)), "Eclipse Shogun title should present")
	await get_tree().process_frame
	_assert_content(card, 3, "Eclipse Shogun", "KAGUTSUCHI COURT")
	_assert(not bool(card.call("present", 4)), "unknown area should be rejected")

	card.call("dismiss_for_playtest")
	await get_tree().process_frame
	var dismissed_value: Variant = card.call("get_current_content_for_playtest")
	var dismissed: Dictionary = dismissed_value as Dictionary if dismissed_value is Dictionary else {}
	_assert(not bool(dismissed.get("visible", true)), "dismissed title card should be hidden")
	card.queue_free()

	SettingsManager.set_value("high_contrast", bool(old_high_contrast))
	SettingsManager.set_value("text_scale", float(old_text_scale))
	await get_tree().process_frame
	print("[OathboundBossTitleCardSmoke] PASS - Keeper | Twin Maws | Eclipse Shogun | localization fallbacks | readability scaling | non-blocking presentation")
	get_tree().quit()


func _assert_content(card: CanvasLayer, area_id: int, expected_title: String, expected_region: String) -> void:
	var content_value: Variant = card.call("get_current_content_for_playtest")
	var content: Dictionary = content_value as Dictionary if content_value is Dictionary else {}
	_assert(int(content.get("area_id", 0)) == area_id, "boss title area drift for %s" % expected_title)
	_assert(str(content.get("title", "")) == expected_title, "boss title fallback drift for area %d" % area_id)
	_assert(str(content.get("region", "")) == expected_region, "boss region fallback drift for area %d" % area_id)
	_assert(bool(content.get("visible", false)), "boss title card should be visible for area %d" % area_id)


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("[OathboundBossTitleCardSmoke] FAIL - %s" % message)
	get_tree().quit(1)
