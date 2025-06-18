extends Node3D

@onready var stage = $stage
@onready var player = $player

@export var defaultScene = PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("world.gd init")
	scaleToMonitor()
	
	# load default scene
	#if defaultScene:
		#loadLevel(defaultScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func scaleToMonitor():
	var resolution = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2i(resolution))
	DisplayServer.window_set_position(Vector2i(0,0))

func loadPlayer():
	var playerScene = load("res://scence/player.tscn").instantiate()
	add_child(playerScene)
	player = playerScene
	

func loadLevel(packedScene: PackedScene):
	# Clear previous scene
	stage.get_children().map(func(child): child.queue_free())

	# init new scene
	var levelInstance = packedScene.instantiate()
	stage.add_child(levelInstance)
	
	# find spawnPoint (node3D)
	var spawnPointNode = levelInstance.get_node_or_null("spawnPoint")
	var spawnPointPos = Vector3.ZERO
	
	if spawnPointNode == null:
		push_error("'spawnPoint' node not found")
	else:
		spawnPointPos = spawnPointNode.global_position

	# set player position
	assert(player, "player null for some reason")
	player.global_position = spawnPointPos
