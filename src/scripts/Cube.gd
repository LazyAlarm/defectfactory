extends Item
class_name  Cube

@onready var cube_mesh : MeshInstance3D = $Cube2/Cube
@onready var audio_stream : AudioStreamPlayer3D = $AudioStreamPlayer3D


var can_rotate : bool = true

const CUBE : StandardMaterial3D = preload("res://src/mesh/materials/cube.tres")
const CUBE_SAD : StandardMaterial3D = preload("res://src/mesh/materials/cube_sad.tres")
const BOX_TURN = preload("res://src/sound/box_turn.wav")
const BOX_DEATH = preload("res://src/sound/box_death.wav")

func aberrate():
	rotation_degrees.x = randi_range(1,3) * 90
	rotation_degrees.y = randi_range(1,3) * 90
	rotation_degrees.z = randi_range(1,3) * 90
	cube_mesh.set_surface_override_material(0,CUBE_SAD)


func _input(_event):
	if !selected or !can_rotate: return
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		can_rotate = false
		var input : Vector2 = Input.get_vector("left","right","down","up")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "quaternion",(Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad(90 * roundi(input.x))).rotated(Vector3.LEFT, deg_to_rad(90 * roundi(input.y))) *   basis).get_rotation_quaternion(), 0.06)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(_done_rotating)
		audio_stream.pitch_scale = randi_range(0.95,1.05)
		audio_stream.stream = BOX_TURN
		audio_stream.play()
		
func _done_rotating():
	global_rotation_degrees = global_rotation_degrees.round()
	if global_rotation_degrees == Vector3.ZERO:
		cube_mesh.set_surface_override_material(0,CUBE)
		on_corrected()
	can_rotate = true

func offscreen():
	if !is_aberration:
		queue_free()
		return
	audio_stream.pitch_scale = randi_range(0.95,1.05)
	audio_stream.stream = BOX_DEATH
	audio_stream.play()
	audio_stream.finished.connect(death)

func death():
	queue_free()

