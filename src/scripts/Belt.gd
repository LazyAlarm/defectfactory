extends Node3D
class_name Belt

@onready var spawner = $Spawner
@onready var area_3d = $Area3D

const CUBE_SCENE : PackedScene = preload("res://src/scenes/cube.tscn")
const BALLOON_SCENE : PackedScene = preload("res://src/scenes/balloon.tscn")
const PRISM_SCENE : PackedScene = preload("res://src/scenes/prism.tscn")

@export var item_type : ITEM_TYPE
enum ITEM_TYPE {
	Cube,
	Balloon,
	Prism
}

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
	
	var determiner : float = randf_range(0, 100)
	if determiner < 10:
		item.aberrate()

func _on_area_entered(area):
	if area.get_parent() is Item:
		area.get_parent().offscreen()
	
