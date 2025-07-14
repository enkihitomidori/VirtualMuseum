extends Node3D

# usage:
# set "cubemapCapture.tscn" as Main scene from project settings
# set "POSITION" coords
# need to copy-paste world's "env" to outside.tscn
# run project
# cubemap images appear in res/cubemap folder

# issues:
# annoying and slow to use
# need to use 3rd party tools to make images into a panorama texture
# 	https://danilw.github.io/GLSL-howto/cubemap_to_panorama_js/cubemap_to_panorama.html

var POSITION := Vector3(42, 22, 70) # where to capture cubemap from

@onready var viewport := $SubViewportContainer/SubViewport
@onready var camera := $SubViewportContainer/SubViewport/Camera3D

var directions = {
	"+X": Vector3(0, 90, 0),
	"-X": Vector3(0, -90, 0),
	"+Y": Vector3(-90, 0, 0),
	"-Y": Vector3(90, 0, 0),
	"+Z": Vector3(0, 0, 0),
	"-Z": Vector3(0, 180, 0),
}

func _ready():
	# create a world and assign it to subviewport
	var world := World3D.new()
	viewport.world_3d = world

	# instance outside scene into the viewports world
	var outside_scene = preload("res://scence/outside.tscn").instantiate()
	assert(outside_scene)
	viewport.add_child(outside_scene)

	# move to pos
	camera.global_position = POSITION

	# wait for scene to init
	await get_tree().process_frame

	var img_dir = ProjectSettings.globalize_path("res://cubemap/")
	DirAccess.make_dir_recursive_absolute(img_dir)

	for name in directions:
		camera.rotation_degrees = directions[name]
		await RenderingServer.frame_post_draw
		var image = viewport.get_texture().get_image()
		image.save_png(img_dir + name + ".png")

	print("Cubemap images saved to: ", img_dir)
	get_tree().quit()
