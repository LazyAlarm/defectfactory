extends Item
class_name Prism

@onready var tilt = $Tilt
@onready var mesh = $Tilt/Mesh


var max_speed : float = 15
var max_angle : float = 80
var accuracy_threshold : float = 5

var speed : float = 20:
	set(value):
		speed = min(max_speed,value)

func aberrate():
	var determiner : int = randi_range(0,1)
	if determiner == 1: tilt.rotate_z(deg_to_rad(randf_range(20,max_angle)))
	else: tilt.rotate_z(deg_to_rad(randf_range(-max_angle,-20)))
	speed = randi_range(0,5)

func _process(delta):
	super._process(delta)
	mesh.rotate_y(delta * speed)
	if !selected: return
	speed += Input.get_action_strength("up")
	if abs(rad_to_deg(tilt.rotation.z)) < accuracy_threshold:
		tilt.rotation.z = 0
		if speed == max_speed:
			on_corrected()
	else:
		tilt.rotate_z(Input.get_axis("left","right") * -delta)
		tilt.rotation.z = clamp(tilt.rotation.z,deg_to_rad(-max_angle),deg_to_rad(max_angle))

