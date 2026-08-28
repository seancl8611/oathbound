extends Node

const EXPECTED_PRESENTER_SCRIPT := "res://Core/Presentation/OathboundAchievementPresenter.gd"


func _ready() -> void:
	await get_tree().process_frame
	var presenter: Node = get_node_or_null("/root/AchievementPresenter")
	_assert(presenter != null, "AchievementPresenter autoload missing")
	_assert(_script_path(presenter) == EXPECTED_PRESENTER_SCRIPT, "wrong AchievementPresenter script")
	_assert(presenter.has_method("present_for_playtest"), "playtest presentation seam missing")
	_assert(presenter.has_method("reset_for_playtest"), "playtest reset seam missing")

	var old_high_contrast: Variant = SettingsManager.get_value("high_contrast", false)
	var old_text_scale: Variant = SettingsManager.get_value("text_scale", 1.0)
	presenter.call("reset_for_playtest")
	SettingsManager.set_value("high_contrast", true)
	SettingsManager.set_value("text_scale", 1.5)
	await get_tree().process_frame

	_assert(bool(presenter.call("present_for_playtest", "keeper_fallen")), "known achievement should present")
	await get_tree().process_frame
	_assert(str(presenter.call("get_current_achievement_id_for_playtest")) == "keeper_fallen", "first achievement id drift")
	_assert(bool(presenter.call("is_visible_for_playtest")), "achievement toast should be visible")
	var first_text_value: Variant = presenter.call("get_current_text_for_playtest")
	var first_text: Dictionary = first_text_value as Dictionary if first_text_value is Dictionary else {}
	_assert(str(first_text.get("kicker", "")).contains("ACHIEVEMENT"), "achievement kicker missing")
	_assert(str(first_text.get("title", "")) == "Open the Way", "achievement title fallback drift")
	_assert(str(first_text.get("description", "")).contains("Keeper"), "achievement description fallback drift")
	_assert(int(presenter.call("get_title_font_size_for_playtest")) >= 27, "text-scale setting not reflected")

	_assert(bool(presenter.call("present_for_playtest", "twin_maws_fallen")), "second achievement should queue")
	_assert(int(presenter.call("get_queue_size_for_playtest")) == 1, "achievement queue did not retain second unlock")
	presenter.call("dismiss_current_for_playtest")
	await get_tree().process_frame
	await get_tree().process_frame
	_assert(str(presenter.call("get_current_achievement_id_for_playtest")) == "twin_maws_fallen", "queued achievement did not advance")
	var second_text_value: Variant = presenter.call("get_current_text_for_playtest")
	var second_text: Dictionary = second_text_value as Dictionary if second_text_value is Dictionary else {}
	_assert(str(second_text.get("title", "")) == "Through the Hunting Grounds", "second achievement title drift")

	presenter.call("reset_for_playtest")
	SettingsManager.set_value("high_contrast", bool(old_high_contrast))
	SettingsManager.set_value("text_scale", float(old_text_scale))
	await get_tree().process_frame
	print("[OathboundAchievementToastSmoke] PASS - unlock signal presentation | queued toasts | localization fallback | readability scaling")
	get_tree().quit()


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("[OathboundAchievementToastSmoke] FAIL - %s" % message)
	get_tree().quit(1)


func _script_path(instance: Object) -> String:
	if instance == null:
		return ""
	var script_value: Variant = instance.get_script()
	return (script_value as Script).resource_path if script_value is Script else ""
