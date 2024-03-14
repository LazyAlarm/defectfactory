extends Node3D
class_name Belt

signal defect_detected
signal defect_corrected
signal one_point

const CUBE_SCENE : PackedScene = preload("res://src/scenes/cube.tscn")
const BALLOON_SCENE : PackedScene = preload("res://src/scenes/balloon.tscn")
const PRISM_SCENE : PackedScene = preload("res://src/scenes/prism.tscn")

@onready var spawn_timer : Timer= $SpawnTimer
@onready var spawner = $Spawner
@onready var area_3d = $Area3D

var scroll_speed : float = 0.3:
	set(value):
		scroll_speed = value
		for item in items:
			item.scroll_speed = value
var spawn_time : float = 1.2:
	set(value):
		spawn_time = value
		spawn_timer.wait_time = spawn_time
var items : Array[Item]

var major_mal_count : int = 0:
	set(value):
		major_mal_count = max(0, value)

var clean_streak_count : int = 0:
	set(value):
		clean_streak_count = max(0, value)

@export var item_type : ITEM_TYPE
enum ITEM_TYPE {
	Cube,
	Balloon,
	Prism
}

func _start_game():
	spawn_timer.start(spawn_time)

func _on_spawn_timer_timeout():
	match item_type:
		ITEM_TYPE.Cube:
			_spawn_item(CUBE_SCENE)
		ITEM_TYPE.Balloon:
			_spawn_item(BALLOON_SCENE)
		ITEM_TYPE.Prism:
			_spawn_item(PRISM_SCENE)
		_:
			printerr(name + " is trying to spawn item of invalid type")


func _spawn_item(scene : PackedScene):
	var item : Item = scene.instantiate()
	get_tree().root.add_child(item)
	item.global_position = spawner.global_position
	item.cam = %Camera3D
	item.scroll_speed = scroll_speed
	var determiner : float = randf_range(0, 100)
	if (determiner < 15 and clean_streak_count <= 0) or major_mal_count > 0:
		item.aberrate()
		item.is_aberration = true
		item.corrected.connect(_on_corrected)
		major_mal_count -= 1
	if major_mal_count <= 0: clean_streak_count -= 1
	items.append(item)

func _on_corrected():
	defect_corrected.emit()

func _on_area_entered(area):
	if area.get_parent() is Item:
		items.remove_at(items.bsearch(area.get_parent()))
		if area.get_parent().is_aberration:
			defect_detected.emit()
		else:
			one_point.emit()
		area.get_parent().offscreen()
	
