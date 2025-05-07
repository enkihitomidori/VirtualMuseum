extends CharacterBody3D

@onready var head: Node3D = $head
#@onready var camera_3d: Camera3D = $head/Camera3D
@onready var raycastHead: RayCast3D = $head/Camera3D/RayCastHead
@onready var raycastFeet: RayCast3D = $RayCastFeet
@onready var gun: Node3D = $head/Camera3D/Gun

var currentSpeed = 5.0
var lookRotation = Vector2()
var cameraRotation : bool = true
var captureMouse : bool = true
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.003

var footstep_sounds = {
	"grass": preload("res://sounds/footstep_grass.ogg"),
	"dirt": preload("res://sounds/footstep_dirt.ogg"),
	"stone": preload("res://sounds/footstep_stone.ogg"),
	#"wood": preload("res://sounds/footstep_wood1.ogg"),
	"default": preload("res://sounds/footstep_default.ogg")
}

# Timers
var footstepTimer = 0.0
var footstepInterval = 0.4
var gunTimer = 0.0
var shootInterval = 0.2


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _input(event):
#	if event is InputEventMouseMotion:
#		rotation.y += (-event.relative.x * MOUSE_SENS)
#		rotation.x += (-event.relative.y * MOUSE_SENS)
#		rotation.x = clamp(rotation.x, -90, 90)
#	
#	if event.is_action_pressed("ui_cancel"):
#		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion and cameraRotation:
		lookRotation.x -= event.relative.x * MOUSE_SENS
		lookRotation.y -= event.relative.y * MOUSE_SENS
		lookRotation.y = clamp(lookRotation.y, -1.5, 1.5)  # Prevent flipping

		rotation.y = lookRotation.x
		head.rotation.x = lookRotation.y

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	# show mouse cursor and lock camera
	if Input.is_key_pressed(KEY_G):
		if captureMouse:
			captureMouse = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cameraRotation = false
		else:
			captureMouse = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			cameraRotation = true
		
	gunTimer -= get_process_delta_time() # this is delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if gunTimer <= 0.0:
			gun.shoot()
			gunTimer = shootInterval


func _physics_process(delta: float) -> void:
	
	# raycast head
	if Input.is_action_just_pressed("interact"):
		#print("interact")
		if raycastHead.is_colliding():
			#print("raycast hit")
			var hit = raycastHead.get_collider()
			var door = hit.get_parent()
			if door and door.has_method("toggle_door"):
				#print("raycast hit door")
				door.toggle_door()
	
	if Input.is_action_pressed("sprint"):
		currentSpeed = SPRINT_SPEED
	else:
		currentSpeed = WALK_SPEED
		
	var isMoving = velocity.length() > 0.1
	
	if isMoving and is_on_floor():
		footstepTimer -= delta * (currentSpeed * 0.2)
		if footstepTimer <= 0.0:
			play_footstep()
			footstepTimer = footstepInterval
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)

	move_and_slide()

func play_footstep():
	if raycastFeet and not raycastFeet.is_colliding():
		return
		
	var collider = raycastFeet.get_collider()
	var surface_type = "default"

	if collider.has_meta("surfaceType"):
		surface_type = collider.get_meta("surfaceType")
		
	#print("Playing footstep sound: ", surface_type)

	var stream = footstep_sounds.get(surface_type, footstep_sounds["default"])

	if stream is Array:
		stream = stream[randi() % stream.size()]

	$FootstepPlayer.stream = stream
	$FootstepPlayer.play()
