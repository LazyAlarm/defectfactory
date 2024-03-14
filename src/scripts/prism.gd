extends Item
class_name Prism

@onready var tilt = $Tilt
@onready var mesh = $Tilt/Mesh
@onready var prism_mesh = $Tilt/Mesh/Prism
@onready var prism_ring = $"Tilt/Mesh/Prism/Prism Ring"
@onready var animation_player = $AnimationPlayer
@onready var audio_stream = $AudioStreamPlayer3D



const PRISM : StandardMaterial3D = preload("res://src/mesh/materials/prism.tres")
const PRISM_GRAY : StandardMaterial3D = preload("res://src/mesh/materials/prism_gray.tres")
const PRISM_GUST = preload("res://src/sound/prism_gust.wav")
const PRISM_SHATTER = preload("res://src/sound/prism_shatter.mp3")

var max_speed : float = 10
var max_angle : float = 80
var accuracy_threshold : float = 5

var speed : float = 10:
	set(value):
		speed = min(max_speed,value)

func _ready():
	animation_player.play("aPrismBob")

func aberrate():
	var determiner : int = randf_range(0,1)
	if determiner == 1: tilt.rotate_z(deg_to_rad(randf_range(20,max_angle)))
	else: tilt.rotate_z(deg_to_rad(randf_range(-max_angle,-20)))
	speed = randf_range(0,2)
	prism_mesh.set_surface_override_material(0,PRISM_GRAY)
	prism_ring.set_surface_override_material(0,PRISM_GRAY)

func _process(delta):
	super._process(delta)
	mesh.rotate_y(delta * -speed)
	animation_player.speed_scale = speed / max_speed
	if !selected: return
	speed += Input.get_action_strength("up") * delta * 14
	if abs(rad_to_deg(tilt.rotation.z)) < accuracy_threshold:
		tilt.rotation.z = 0
		if speed == max_speed:
			on_corrected()
			audio_stream.stream = PRISM_GUST
			audio_stream.pitch_scale = randf_range(0.95,1.05)
			audio_stream.play()
			prism_mesh.set_surface_override_material(0,PRISM)
			prism_ring.set_surface_override_material(0,PRISM)
	else:
		tilt.rotate_z(Input.get_axis("left","right") * -delta * 3)
		tilt.rotation.z = clamp(tilt.rotation.z,deg_to_rad(-max_angle),deg_to_rad(max_angle))

func offscreen():
	if !is_aberration:
		queue_free()
		return
	audio_stream.pitch_scale = randf_range(0.95,1.05)
	audio_stream.stream = PRISM_SHATTER
	audio_stream.play()
	audio_stream.finished.connect(death)

func death():
	queue_free()
