extends Item
class_name Balloon

var min_scale : float = 0.5
var max_scale : float = 2
var accuracy_threshold : float = 0.05


func aberrate():
	var determiner : int = randi_range(0,4)
	if determiner == 4: scale = Vector3.ONE * randf_range(1.3, 2)
	else: scale = Vector3.ONE * randf_range(0.5, 0.8)


func _process(delta):
	super._process(delta)
	if !selected: return
	var input : float = Input.get_axis("down","up")
	scale += Vector3.ONE * input * delta
	if scale.x > max_scale:
		scale = Vector3.ONE * max_scale
	elif scale.x < min_scale:
		scale = Vector3.ONE * min_scale
	if abs(1 - scale.x) < accuracy_threshold:
		scale = Vector3.ONE
		corrected()
