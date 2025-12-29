extends Control

@onready var grid = $CenterContainer/Grid
@onready var paint_grid = $CenterContainer2/PaintGrid

var timer:int = 0

var level_status = 'picross'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer2.hide()
	$ConfirmScreen.hide()
	grid.setup_puzzle(Global.current_level_data)
	grid.init_game()
	$CenterContainer.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	$ConfirmScreen.show()

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")

func _on_cancel_button_pressed() -> void:
	$ConfirmScreen.hide()

func _on_timer_timeout() -> void:
	if $ConfirmScreen.is_visible_in_tree() == false and level_status == 'picross':
		timer += 1
		var x = int(timer / 60.0)
		var y = timer - x * 60
		$PuzzleTimerLabel.text = '%02d:%02d' % [x, y]

func _on_grid_picross_solved() -> void:
	level_status = 'paint'
	$PuzzleTimerLabel.hide()
	$CenterContainer.hide()
	paint_grid.setup_puzzle(Global.current_level_data)
	paint_grid.init_game()
	$CenterContainer2.show()
	
