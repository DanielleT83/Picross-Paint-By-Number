extends Control

@onready var grid = $CenterContainer/Grid
@onready var paint_grid = $PaintGrid

var timer:int = 0
var current_data = Global.current_level_data
var level_status = 'picross'


# Called when the node enters the scene tree for the first time.
# Sets up the puzzle.
func _ready() -> void:
	paint_grid.hide()
	$ConfirmScreen.hide()
	$SolvedScreen.hide()
	$ContinueButton.hide()
	$SolvedLabel.hide()
	$TitleLabel.text = current_data.title
	$TitleLabel.hide()
	grid.setup_puzzle(current_data)
	grid.init_game()
	$CenterContainer.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called when the back button is pressed --> goes back to level select if on the puzzle, goes back to the puzzle if in settings.
func _on_texture_button_pressed() -> void:
	if !$SettingsScreen.is_visible():
		$ConfirmScreen.show()
	elif $SettingsScreen.is_visible():
		$SettingsScreen.hide()
		$SettingsScreen/ClearLabel.hide()
		$SettingsScreen/ClearButton.hide()
		
# Confirms that the user wants to exit the puzzle to level select.
func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")

# Takes the user back to the puzzle from the confirm screen.
func _on_cancel_button_pressed() -> void:
	$ConfirmScreen.hide()

# Updates the puzzle timer each second that the user is on the puzzle.
func _on_timer_timeout() -> void:
	if $ConfirmScreen.is_visible_in_tree() == false and level_status != 'done' and $SettingsScreen.is_visible_in_tree() == false:
		timer += 1
		var x = int(timer / 60.0)
		var y = timer - x * 60
		$PuzzleTimerLabel.text = '%02d:%02d' % [x, y]

# Switches to paint by number grid when the picross puzzle is solved.
func _on_grid_picross_solved() -> void:
	level_status = 'paint'
	$CenterContainer.hide()
	paint_grid.setup_puzzle(Global.current_level_data)
	paint_grid.init_game()
	paint_grid.layout_level()
	paint_grid.show()

# Shows the 'puzzle solved screen' when the paint by number is completed.
func _on_paint_grid_paint_by_number_solved() -> void:
	level_status = 'done'
	$PaintGrid/ColorNumGrid.hide()
	$PaintGrid/ColorGrid.hide()
	$BackButton.hide()
	$SettingsButton.hide()
	$SolvedScreen.show()
	$SolvedTimer1.start()

# Takes the user back to level select from the puzzle solved screen.
func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")

# Shows certain text on the solved screen after a brief pause.
func _on_solved_timer_1_timeout() -> void:
	$SolvedLabel.show()
	$TitleLabel.show()
	$SolvedTimer2.start()

# Shows the proceed button on the solved screen after a brief pause.
func _on_solved_timer_2_timeout() -> void:
	$ContinueButton.show()
	current_data.solved_state = true
	Global.mark_level_solved(Global.current_level_data.resource_path)

# Shows the settings screen.
func _on_settings_button_pressed() -> void:
	$SettingsScreen.show()
	$SettingsScreen/ClearLabel.show()
	$SettingsScreen/ClearButton.show()
	if grid.is_visible_in_tree() == true:
		$SettingsScreen/ClearButton.disabled = false
	else:
		$SettingsScreen/ClearButton.disabled = true

# Clears/resets the picross puzzle.
func _on_clear_button_pressed() -> void:
	grid.reset_grid()
	$SettingsScreen.hide()
	$SettingsButton.show()
