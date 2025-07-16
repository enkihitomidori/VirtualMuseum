# MusicObject tool 0.1

@tool
extends Node3D

# issues:
# "audioRadius" is null at runtime for some reason


@onready var audioRadius: Node3D = $audioRadius
@onready var musicPlayer: AudioStreamPlayer3D = $musicPlayer   


@export var volume: int = 50:
	set(value):
		if value:
			volume = value

@export_file("*.mp3", "*.ogg", "*.wav") var musicTrack:
	set(value):
		if value:
			musicTrack = value
			_updateMusicTrack()

@export var viewRadius: bool = false:
	set(value):
		viewRadius = value
		if viewRadius:
			_updateVisualDistance()
		else:
			_clearVisualRadius()
		
@export var distance: float = 100:
	set(value):
		if value > 0:
			distance = value
			if viewRadius:
				_updateVisualDistance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("musicPlayer.gd init")
	assert(audioRadius, "audioRadius is null")
	assert(musicPlayer, "musicPlayer is null")
	assert(musicTrack, "musicTrack is null")
	
	_clearVisualRadius()
	_updateMusicTrack()
	
	musicPlayer.play()
	musicPlayer.autoplay = true
	musicPlayer.volume_db = volume
	musicPlayer.max_distance = distance
	
#func _process(val):
	#if !musicPlayer.playing:
		#musicPlayer.play()
	#musicPlayer.autoplay = false

func _updateMusicTrack():
	if !musicPlayer:
		print("musicPlayer IS NULL")
		#assert(0)
		return
		
		
	if musicTrack:
		var musicFile = load(musicTrack)
		if musicFile:
			musicPlayer.stream = musicFile
		else:
			push_error("Music file error")

func _clearVisualRadius():
	if !audioRadius:
		push_error("audioRadius null?")
		return
		
	for child in audioRadius.get_children():
		child.queue_free()


func _updateVisualDistance():
	
	# fix for audioRadius being null at runtime
	if !audioRadius:
		return
		
	_clearVisualRadius()
	
	var radius = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = distance
	sphere.height = distance * 2
	
	var material = StandardMaterial3D.new()
	var color = Color(0.5, 0.5, 1.0, 0.4)
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	sphere.material = material
	
	radius.mesh = sphere
	
	audioRadius.add_child(radius)
