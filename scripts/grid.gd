extends Control

@onready var grid:GridContainer = $GridContainer
enum CellState {EMPTY, FILLED, MARKED}

signal picross_solved
var picross_solved_check = false

var grid_size: int
var column_clues: Array
var row_clues: Array
var puzzle_solution: Array
var row_clue_labels: Array = []
var column_clue_labels: Array = []
var game_grid: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup_puzzle(level_data: LevelData):
	grid_size = level_data.grid_width
	column_clues = level_data.column_clues
	row_clues = level_data.row_clues
	puzzle_solution = level_data.solution

func init_game():
	grid.columns = grid_size
	_populate_grid()
	
	custom_minimum_size = Vector2(grid_size * 42, grid_size * 42)

func _populate_grid():
	game_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_button())
		game_grid.append(row)
	
	for i in range(grid_size):
		var row_clue = create_clue(row_clues[i], "row", i)
		add_child(row_clue)
		row_clue_labels.append(row_clue)
		
		var column_clue = create_clue(column_clues[i], "column", i)
		add_child(column_clue)
		column_clue_labels.append(column_clue)

func create_button():
	var button := TextureButton.new()
	button.toggle_mode = true
	button.texture_normal = preload("res://assets/tile_empty.png")
	button.custom_minimum_size = Vector2(42, 42)
	
	button.set_meta("state", CellState.EMPTY)
	
	button.pressed.connect(_on_button_left_pressed.bind(button))
	button.gui_input.connect(_on_button_gui_input.bind(button))
	
	grid.add_child(button)
	return button

func create_clue(clue_text, clue_type:String, pos:int):
	var clue = Label.new()
	var text: String
	
	text = str(clue_text)
	var chars_to_replace = [",", "[", "]"]
	for x in chars_to_replace:
		text = text.replace(x, "")
	
	if text == "0":
		clue.add_theme_color_override("font_color", Color("#44664ac8"))
	else:
		clue.add_theme_color_override("font_color", Color("#d7e9d8"))
	clue.add_theme_font_size_override("font_size", 20)
	
	if clue_type == "row":
		clue.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		clue.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		clue.text = text
		clue.position = Vector2(grid.position.x - 40, grid.position.y + (pos * 42) + 6)
	elif clue_type == "column":
		clue.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		clue.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		clue.text = text.replace(" ", "\n")
		clue.position = Vector2(grid.position.x + (pos * 42) + 15, grid.position.y - 92)	
	return clue

func _on_button_left_pressed(button: TextureButton):
	if button.button_pressed:
		button.texture_pressed = preload("res://assets/tile_filled.png")
		button.set_meta("state", CellState.FILLED)
	else:
		button.set_meta("state", CellState.EMPTY)
	
	check_puzzle()

func _on_button_gui_input(event: InputEvent, button: TextureButton):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("right_click"):
			button.texture_pressed = preload("res://assets/tile_x.png")
			button.button_pressed = not button.button_pressed
			button.set_meta("state", CellState.MARKED)
	check_puzzle()

func check_puzzle():
	var puzzle_state = []
	
	for row in game_grid:
		var current_row = []
		for cell in row:
			if cell.get_meta("state") == CellState.FILLED and cell.button_pressed == true:
				current_row.append(1)
			else:
				current_row.append(0)
		puzzle_state.append(current_row)
		
	update_clue_colors()
	
	if puzzle_state == puzzle_solution and picross_solved_check == false:
		picross_solved.emit()
		picross_solved_check = true

func get_current_clues(cell_states: Array):
	var clues = []
	var counter = 0
	for state in cell_states:
		if state == CellState.FILLED:
			counter += 1
		else:
			if counter > 0:
				clues.append(counter)
				counter = 0
	if counter > 0:
			clues.append(counter)
		
	if len(clues) == 0:
		return [0]
		
	return clues

func update_clue_colors():
	# checking rows
	for y in range(grid_size):
		var row_states = []
		for x in range(grid_size):
			var button = game_grid[y][x]
			if button.button_pressed and button.get_meta("state") == CellState.FILLED:
				row_states.append(CellState.FILLED)
			else:
				row_states.append(CellState.EMPTY)
		if get_current_clues(row_states) == row_clues[y]:
			row_clue_labels[y].add_theme_color_override("font_color", Color("#44664ac8"))
		else:
			row_clue_labels[y].add_theme_color_override("font_color", Color("#d7e9d8"))
		
	# checking columns
	for x in range(grid_size):
		var column_states = []
		for y in range(grid_size):
			var button = game_grid[y][x]
			if button.button_pressed and button.get_meta("state") == CellState.FILLED:
				column_states.append(CellState.FILLED)
			else:
				column_states.append(CellState.EMPTY)
		if get_current_clues(column_states) == column_clues[x]:
			column_clue_labels[x].add_theme_color_override("font_color", Color("#44664ac8"))
		else:
			column_clue_labels[x].add_theme_color_override("font_color", Color("#d7e9d8"))
