extends Item
class_name Balloon

var max_scale : float = 2



func aberrate():
	var determiner : int = randi_range(0,4)
	if determiner == 4: scale = Vector3.ONE * randf_range(1.3, 2)
	else: scale = Vector3.ONE * randf_range(0.6, 0.9)


func _process(delta):
	super._process(delta)
	if !selected: return
	var input : float = Input.get_axis("down","up")
	scale += Vector3.ONE * input * delta
	if scale.x > max_scale:
		scale = Vector3.ONE * max_scale
