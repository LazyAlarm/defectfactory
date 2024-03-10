extends Item

func _ready():
	aberrate()

func aberrate():
	scale = Vector3.ONE * randf_range(0.6, 0.9)

func _process(delta):
	super._process(delta)
	if selected and Input.is_action_pressed("up"):
		scale += Vector3.ONE * delta
	
func _input(event):
	if not selected or not (event is InputEventMouseButton): return
	if Input.is_action_just_pressed("pop"):
		pop()

func pop():
	queue_free()
