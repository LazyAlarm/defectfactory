extends Node3D


@onready var malfunction_timer = $MalfunctionTimer
@onready var belt_1 = $Belt
@onready var belt_2 = $Belt2
@onready var belt_3 = $Belt3

#UI
@onready var lives_label = $UI/Lives
@onready var points_label = $UI/Points


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
	malfunction_timer.start(randi_range(malfunction_timer_range.x,malfunction_timer_range.y))
	belt_1.defect_detected.connect(_defect_detected)
	belt_2.defect_detected.connect(_defect_detected)
	belt_3.defect_detected.connect(_defect_detected)
	belt_1.defect_corrected.connect(_defect_corrected)
	belt_2.defect_corrected.connect(_defect_corrected)
	belt_3.defect_corrected.connect(_defect_corrected)
	belt_1.one_point.connect(_one_point)
	belt_2.one_point.connect(_one_point)
	belt_3.one_point.connect(_one_point)

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
	get_tree().paused = true
