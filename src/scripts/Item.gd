extends Node3D
class_name Item
class hello:
	extends Node3D
	var hello := 0

@onready var cam = $"../../Camera3D"

var can_rotate : bool = true

func _process(delta):
	position.x += -delta * 0.3



func _input(event):
	if !can_rotate: return
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		var raydata : Dictionary = ray_from_mouse_pos(get_viewport().get_mouse_position(),0)
		if raydata.size() > 0:
			if !get_children().has(raydata["collider"]):
				return
			can_rotate = false
			var cube : Node3D = raydata["collider"].get_parent_node_3d()
			var input : Vector2 = Input.get_vector("left","right","down","up")
			var tween = get_tree().create_tween()
			if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
				tween.tween_property(cube, "global_basis", cube.global_basis.rotated(Vector3.UP, deg_to_rad(90) * roundi(input.x)).orthonormalized(), 0.1)
			elif Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
				tween.tween_property(cube, "global_basis", cube.global_basis.rotated(Vector3.LEFT, deg_to_rad(90) * roundi(input.y)).orthonormalized(), 0.1)
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(_done_rotating)

func _done_rotating():
	print_debug("done")
	can_rotate = true

func ray_from_mouse_pos(mouse_pos, collision_mask):
	var ray_start = cam.project_ray_origin(mouse_pos)
	var ray_end = ray_start + cam.project_ray_normal(mouse_pos) * 50
	var world3D : World3D = get_world_3d()
	var space_state = world3D.direct_space_state
	if space_state == null: return
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true
	#query.collide_with_bodies = true
	
	return space_state.intersect_ray(query)



func _on_screen_exited():
	position.x = 3
