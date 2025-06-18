extends Control

func _ready():
	print("MainMenuScene.gd init")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed():
	print("PLAY")
	
	var world_node = get_tree().get_root().get_node("world")
	
	world_node.loadPlayer()
	world_node.loadLevel(world_node.defaultScene)
	
	# remove ui node
	queue_free()

func _on_settings_button_pressed():
	print("SETTINGS (WIP)")

func _on_quit_button_pressed():
	print("QUIT")
	get_tree().quit()
