extends Node3D
class_name Item
class hello:
	extends Node3D
	var hello := 0

@onready var cam = $"../../Camera3D"


func _process(delta):
	position.x += -delta
	var raydata : Dictionary = ray_from_mouse_pos(get_viewport().get_mouse_position(),0)
	if raydata.size() > 0:
		print_debug(raydata)
		var collider : Area3D = raydata["collider"]
		collider.get_parent_node_3d().rotate_z(-delta * 0.5)
	
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
