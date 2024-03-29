extends Node3D
class_name Item

signal corrected

var scroll_speed : float = 0.3
var cam : Camera3D
var selected : bool = false
var is_aberration : bool = false
var dead : bool = false

func _process(delta):
	position.x += -delta * scroll_speed
	var raydata : Dictionary = ray_from_mouse_pos(get_viewport().get_mouse_position(),0)
	selected = is_aberration and raydata.size() > 0 and get_children().has(raydata["collider"])
	

func update_speed(new_speed : float):
	scroll_speed = new_speed

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

func on_corrected():
	is_aberration = false
	corrected.emit()

func offscreen():
	queue_free()
