extends Node3D
class_name Item

@onready var cam = $"../../Camera3D"
var selected : bool = false


func _process(delta):
	position.x += -delta * 0.3
	var raydata : Dictionary = ray_from_mouse_pos(get_viewport().get_mouse_position(),0)
	selected = raydata.size() > 0 and get_children().has(raydata["collider"])

func ray_from_mouse_pos(mouse_pos, collision_mask):
	var ray_start = cam.project_ray_origin(mouse_pos)
	var ray_end = ray_start + cam.project_ray_normal(mouse_pos) * 50
	var world3D : World3D = get_world_3d()
	var space_state = world3D.direct_space_state
	if space_state == null: return
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)

func aberrate():
	printerr(name + " has no defined aberrate method")

func _on_screen_exited():
	position.x = 3
