extends Node3D

@onready var animPlayer = $AnimationPlayer
@export_file("*.tscn") var targetScenePath: String
#@onready var area = $Area3D

var isOpen = false

func _ready():
	print("caelum_door.gd init")

func toggle_door():
	
	# play door animation ("door_close" is currently not used)
	if isOpen:
		animPlayer.play("door_close")
	else:
		animPlayer.play("door_open")
		
	# toggle door state (currently useless)
	isOpen = !isOpen
	
	# wait for animation to finish
	if isOpen and not targetScenePath.is_empty():
		await animPlayer.animation_finished

	# load targetScene
	if isOpen:
		if targetScenePath.is_empty():
			push_warning("Door is missing targetScenePath")
			return

		var packedScene = load(targetScenePath)
		if not packedScene or not packedScene is PackedScene:
			push_error("Failed to load scene at: %s" % targetScenePath)
			return

		var world = get_tree().get_root().get_node("caelumInside")
		world.loadLevel(packedScene)
