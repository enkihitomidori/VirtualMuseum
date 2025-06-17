extends Node3D

# this is just a test for (kinda) automated art + model combo object thing
# this script comes with "artObject.tscn"
# feel free to remove

@export_file("*.glb") var targetModel: String
@export_file("*.jpg", "*.png") var targetPainting: String

@onready var Painting: Sprite3D = $Painting
@onready var Model: Node3D = $Model

func _ready() -> void:
	assert(targetModel, "targetModelPath missing")
	assert(targetPainting, "targetPaintingPath missing")
	
	# set placeholder model invisible
	Model.get_child(0).visible = false
	
	# load model
	var modelScene = load(targetModel)
	if modelScene is PackedScene:
		var model_instance = modelScene.instantiate()
		Model.add_child(model_instance)
	else:
		push_error("Failed to load GLB scene from: " + targetModel)
		
	# set placeholder texture invisible
	Painting.get_child(0).visible = false
	
	# load texture
	Painting.texture = load(targetPainting)
