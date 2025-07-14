# artObject 2.0

@tool
extends Node3D

#@export_file("*.glb") var targetModel: String:
	#set(value):
		#targetModel = value
		#_update_model()

@export_file("*.jpg", "*.png") var targetPainting: String:
	set(value):
		targetPainting = value
		_update_texture()

@onready var Painting: Sprite3D = $Painting
@onready var Model: Node3D = $Model

func _ready() -> void:
	_update_texture()
	#_update_model()

func _update_texture() -> void:
	if not Painting or not targetPainting:
		return

	var text = load(targetPainting)
	if text:
		Painting.texture = text

# wip and NOT tested
#func _update_model() -> void:
	#if not Model or not targetModel:
		#return
		
	#var modelScene = load(targetModel)
	#if modelScene is PackedScene:
		#for child in Model.get_children():
			#if child != Model.get_child(0):
				#child.queue_free()
		#var model_instance = modelScene.instantiate()
		#Model.add_child(model_instance)
	#else:
		#push_error("Failed to load .glb scene from: " + targetModel)
