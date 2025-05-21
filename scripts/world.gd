extends Node3D

@onready var stage = $stage
@onready var player = $player

@export var defaultScene = PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("world.gd init")
	
	# load default scene
	if defaultScene:
		loadLevel(defaultScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	player.global_position = spawnPointPos
