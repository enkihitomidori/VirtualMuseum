extends Node3D

const maxDecals : int = 100
var decalCount : int = 0
@onready var impactRay: RayCast3D = $impactRay

var gunshot = preload("res://sounds/gunshot.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$gunPlayer.stream = gunshot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	print("pew")
	
	if impactRay.is_colliding() and decalCount < maxDecals:
		decalCount += 1
		var collision = impactRay.get_collision_point()
		$gunPlayer.play()
		spawnDecal(collision, collision.normalized())
	
func spawnDecal(pos: Vector3, normal: Vector3):
	# TODO: fix: spawned decal gets squished on vertical surfaces
	
	var decal = Decal.new()
	var texture = preload("res://assets/textures/splat.png") as Texture2D
	decal.texture_albedo = texture
	decal.size = Vector3(0.3, 0.3, 0.3)

	# center decal (scaling not working)
	#pos.x -= texture.get_size().x * 0.5
	#pos.z -= texture.get_size().y * 0.5
	
	decal.global_transform.origin = pos
	decal.look_at(position + normal)
	
	get_tree().current_scene.add_child(decal)
