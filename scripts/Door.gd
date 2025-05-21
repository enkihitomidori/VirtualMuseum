extends Node3D

@onready var animPlayer = $AnimationPlayer
@export_file("*.tscn") var targetScenePath: String
#@onready var area = $Area3D

var isOpen = false

func _ready():
	print("door.gd init")

func toggle_door():
	if isOpen:
		animPlayer.play("door_close")
	else:
		animPlayer.play("door_open")
	isOpen = !isOpen
	
	if isOpen and not targetScenePath.is_empty():
		await animPlayer.animation_finished

	if isOpen:
		if targetScenePath.is_empty():
			push_warning("Door is missing targetScenePath")
			return

		var packedScene = load(targetScenePath)
		if not packedScene or not packedScene is PackedScene:
			push_error("Failed to load scene at: %s" % targetScenePath)
			return

		var world = get_tree().get_root().get_node("world")
		world.loadLevel(packedScene)
