extends Item
class_name Balloon
@onready var balloon_mesh : MeshInstance3D = $ScalePivot/Balloon2/Balloon
@onready var scale_point = $ScalePivot
const BALLOON_BLUE : StandardMaterial3D = preload("res://src/mesh/materials/balloon_blue.tres")
const BALLOON_GREEN : StandardMaterial3D = preload("res://src/mesh/materials/balloon_green.tres")
const BALLOON_PINK : StandardMaterial3D = preload("res://src/mesh/materials/balloon_pink.tres")
const BALLOON_RED : StandardMaterial3D = preload("res://src/mesh/materials/balloon_red.tres")
const BALLOON_YELLOW : StandardMaterial3D = preload("res://src/mesh/materials/balloon_yellow.tres")

const BALLOON_GRAY : StandardMaterial3D = preload("res://src/mesh/materials/balloon_gray.tres")

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
	if !selected: return
	var input : float = Input.get_axis("down","up")
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
