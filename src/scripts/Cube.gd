extends Item
class_name  Cube

var can_rotate : bool = true

func aberrate():
	rotation_degrees.y = randi_range(1,3) * 90
	rotation_degrees.z = randi_range(1,3) * 90


func _input(_event):
	if !selected or !can_rotate: return
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		can_rotate = false
		var input : Vector2 = Input.get_vector("left","right","down","up")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "quaternion",(Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad(90 * roundi(input.x))).rotated(Vector3.LEFT, deg_to_rad(90 * roundi(input.y))) *   basis).get_rotation_quaternion(), 0.1)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(_done_rotating)
		

func _done_rotating():
	global_rotation_degrees = global_rotation_degrees.round()
	if global_rotation_degrees == Vector3.ZERO:
		corrected()
	can_rotate = true

