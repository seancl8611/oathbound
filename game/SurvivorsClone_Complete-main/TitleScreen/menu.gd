extends Control

var hub = "res://World/HubScene.tscn"

func _on_btn_play_click_end():
	var _hub = get_tree().change_scene_to_file(hub)

func _on_btn_exit_click_end():
	get_tree().quit()
