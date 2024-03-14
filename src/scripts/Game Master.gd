extends Node3D


@onready var malfunction_timer = $MalfunctionTimer
@onready var belt_1 : Belt = $Belt
@onready var belt_2 : Belt = $Belt2
@onready var belt_3 : Belt = $Belt3

#UI
@onready var lives_label = $UI/Lives
@onready var points_label = $UI/Points
@onready var title_menu = $"UI/Title Menu"
@onready var start_button = $"UI/Title Menu/Start"
@onready var pause = $UI/Pause



var escalation_rate : float = 0.01
var is_playing : bool = false
var scroll_speed : float = 0.3:
	set(value):
		scroll_speed = value
		_update_scroll_speed()
var spawn_time : float = 1.2:
	set(value):
		spawn_time = value
		_update_spawn_time()
var lives : int = 5
var points : int = 0
var selected_belt : int = Belt_01
var malfunction_count : int = 10
var malfunction_timer_range : Vector2 = Vector2(30,60)

enum {
	Belt_01,
	Belt_02,
	Belt_03
}


func _ready():
	belt_1.defect_detected.connect(_defect_detected)
	belt_2.defect_detected.connect(_defect_detected)
	belt_3.defect_detected.connect(_defect_detected)
	belt_1.defect_corrected.connect(_defect_corrected)
	belt_2.defect_corrected.connect(_defect_corrected)
	belt_3.defect_corrected.connect(_defect_corrected)
	belt_1.one_point.connect(_one_point)
	belt_2.one_point.connect(_one_point)
	belt_3.one_point.connect(_one_point)
	title_menu.show()
	

func _start_game():
	belt_1._start_game()
	belt_2._start_game()
	belt_3._start_game()
	malfunction_timer.start(randi_range(malfunction_timer_range.x,malfunction_timer_range.y))
	is_playing = true

func _process(delta):
	if !is_playing: return
	escalation_rate = lerp(escalation_rate,0.001, delta * 0.01)
	scroll_speed = lerp(scroll_speed,1.0, delta * escalation_rate)
	spawn_time = lerp(spawn_time,0.5,delta * escalation_rate)
	print_debug(spawn_time)
	print_debug(escalation_rate)

func _update_scroll_speed():
	belt_1.scroll_speed = scroll_speed
	belt_2.scroll_speed = scroll_speed
	belt_3.scroll_speed = scroll_speed

func _update_spawn_time():
	belt_1.spawn_time = spawn_time
	belt_2.spawn_time = spawn_time
	belt_3.spawn_time = spawn_time

func _defect_detected():
	lives -= 1
	lives_label.text = "Alloted Errors: " + str(lives)
	if lives <= 0:
		_game_over()

func _defect_corrected():
	points += 5
	points_label.text = "Points: " + str(points)

func _one_point():
	points += 1
	points_label.text = "Points: " + str(points)

func _on_malfunction_timer_timeout():
	print_debug("Major Malfunction")
	selected_belt = randi_range(0,2)
	belt_1.major_mal_count = malfunction_count if selected_belt == Belt_01 else 0
	belt_1.clean_streak_count = malfunction_count
	belt_2.major_mal_count = malfunction_count if selected_belt == Belt_02 else 0
	belt_2.clean_streak_count = malfunction_count
	belt_3.major_mal_count = malfunction_count if selected_belt == Belt_03 else 0
	belt_3.clean_streak_count = malfunction_count
	malfunction_timer.start(randi_range(malfunction_timer_range.x,malfunction_timer_range.y))

func _game_over():
	print_debug("Game Over")
	$"UI/Game Over".show()
	get_tree().paused = true

func _input(event):
	if !is_playing: return
	if Input.is_action_just_released("escape"):
		if get_tree().paused:
			get_tree().paused = false
			pause.hide()
		else:
			get_tree().paused = true
			pause.show()
			

func _on_start_button_up():
	title_menu.hide()
	_start_game()


func _on_restart_button_up():
	get_tree().quit()
	


func _on_resume_button_up():
	get_tree().paused = false
	pause.hide()


func _on_quit_button_up():
	get_tree().quit()
