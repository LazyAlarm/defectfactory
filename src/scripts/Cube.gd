extends Item


var can_rotate : bool = true

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
	can_rotate = true

