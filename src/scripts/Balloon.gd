extends Item
class_name Balloon
@onready var balloon_mesh : MeshInstance3D = $ScalePivot/Balloon2/Balloon
@onready var scale_point = $ScalePivot
@onready var audio_player = $AudioStreamPlayer3D
const BALLOON_BLUE : StandardMaterial3D = preload("res://src/mesh/materials/balloon_blue.tres")
const BALLOON_GREEN : StandardMaterial3D = preload("res://src/mesh/materials/balloon_green.tres")
const BALLOON_PINK : StandardMaterial3D = preload("res://src/mesh/materials/balloon_pink.tres")
const BALLOON_RED : StandardMaterial3D = preload("res://src/mesh/materials/balloon_red.tres")
const BALLOON_YELLOW : StandardMaterial3D = preload("res://src/mesh/materials/balloon_yellow.tres")

const BALLOON_GRAY : StandardMaterial3D = preload("res://src/mesh/materials/balloon_gray.tres")

const BALLOON_DEFLATE = preload("res://src/sound/balloon_deflate.mp3")
const BALLOON_INFLATE = preload("res://src/sound/balloon_inflate.mp3")
const BALLOON_POP = preload("res://src/sound/balloon_pop.mp3")

var min_scale : float = 0.5
var max_scale : float = 2
var accuracy_threshold : float = 0.05

func _ready():
	_randomize_balloon_colour()


func aberrate():
	balloon_mesh.set_surface_override_material(0,BALLOON_GRAY)
	var determiner : int = randi_range(0,4)
	if determiner == 4: scale_point.scale = Vector3.ONE * randf_range(1.3, 2)
	else: scale_point.scale = Vector3.ONE * randf_range(0.5, 0.8)
		

func _process(delta):
	super._process(delta)
	if !selected and !dead:
		audio_player.stop()
		return
	var input : float = Input.get_axis("down","up")
	if input < -0.1:
		if audio_player.stream != BALLOON_DEFLATE:
			audio_player.pitch_scale = randf_range(0.95,1.05)
			audio_player.stream = BALLOON_DEFLATE
	elif input > 0.1:
		if audio_player.stream != BALLOON_INFLATE:
			audio_player.pitch_scale = randf_range(0.95,1.05)
			audio_player.stream = BALLOON_INFLATE
	if is_aberration and !audio_player.playing and abs(input) > 0.2:
		audio_player.play()
	scale_point.scale += Vector3.ONE * input * delta
	if scale_point.scale.x > max_scale:
		scale_point.scale = Vector3.ONE * max_scale
	elif scale_point.scale.x < min_scale:
		scale_point.scale = Vector3.ONE * min_scale
	if abs(1 - scale_point.scale.x) < accuracy_threshold:
		scale_point.scale = Vector3.ONE
		on_corrected()
		_randomize_balloon_colour()

func _randomize_balloon_colour():
	var determiner : int = randi_range(0,4)
	match determiner:
		0:
			balloon_mesh.set_surface_override_material(0,BALLOON_BLUE)
		1:
			balloon_mesh.set_surface_override_material(0,BALLOON_GREEN)
		2:
			balloon_mesh.set_surface_override_material(0,BALLOON_PINK)
		3:
			balloon_mesh.set_surface_override_material(0,BALLOON_RED)
		4:
			balloon_mesh.set_surface_override_material(0,BALLOON_YELLOW)

func offscreen():
	if !is_aberration:
		queue_free()
		return
	dead = true
	audio_player.pitch_scale = randf_range(0.95,1.05)
	audio_player.stream = BALLOON_POP
	audio_player.play()
	audio_player.finished.connect(_balloon_popped)
	print_debug("Yeah")

func _balloon_popped():
	queue_free()
