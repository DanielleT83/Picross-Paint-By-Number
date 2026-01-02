extends Control

@onready var grid:GridContainer = $ButtonGrid
@onready var number_grid:GridContainer = $NumGrid
@onready var color_grid:GridContainer = $ColorGrid
@onready var color_num_grid:GridContainer = $ColorNumGrid
enum CellState {EMPTY, FILLED}

const grids_gap := 20

var grid_size: int
var colors: Array
var paint_clues: Array
var picross_solution: Array
var game_grid = []
var num_grid = []
var color_squares: Array
var current_color: Color
var current_number: int

signal paint_by_number_solved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup_puzzle(level_data: LevelData):
	grid_size = level_data.grid_width
	colors = level_data.colors
	paint_clues = level_data.paint_clues
	picross_solution = level_data.solution

func init_game():
	grid.columns = grid_size
	number_grid.columns = grid_size
	number_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_grid.columns = len(colors)
	color_num_grid.columns = len(colors)
	color_num_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_populate_grid()
	
	grid.custom_minimum_size = Vector2(grid_size * 42, grid_size * 42)
	number_grid.custom_minimum_size = Vector2(grid_size * 42, grid_size * 42)
	color_grid.custom_minimum_size = Vector2(len(colors) * 42, len(colors) * 42)
	color_num_grid.custom_minimum_size = Vector2(len(colors) * 42, len(colors) * 42)
	
	color_squares = color_grid.get_children()

func _populate_grid():
	#creating the grid squares (buttons) 
	game_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_button(x, i))
		game_grid.append(row)
	
	#creating the grid numbers
	num_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_number(x, i))
		num_grid.append(row)
		
	for i in range(len(colors)):
		create_color_button(i)

func layout_level():
	var viewport_center = get_viewport_rect().size / 2
	
	var top_grids_size = grid.get_combined_minimum_size()
	var bottom_grids_size = color_grid.get_combined_minimum_size()
	
	var top_grids_pos = viewport_center - top_grids_size / 2
	grid.position = top_grids_pos
	number_grid.position = top_grids_pos
	
	var bottom_y = top_grids_pos.y + top_grids_size.y + grids_gap
	var bottom_x = viewport_center.x - bottom_grids_size.x / 2
	var bottom_grids_pos = Vector2(bottom_x, bottom_y)
	color_grid.position = bottom_grids_pos
	color_num_grid.position = bottom_grids_pos

func create_button(row: int, column: int):
	var button := Button.new()
	
	var normal_stylebox := StyleBoxFlat.new()
	if picross_solution[column][row] == 0:
		normal_stylebox.bg_color = Color("#d7e9d8")
	elif picross_solution[column][row] == 1:
		normal_stylebox.bg_color = Color("#a8baa9")
	normal_stylebox.border_width_left = 2
	normal_stylebox.border_width_right = 2
	normal_stylebox.border_width_top = 2
	normal_stylebox.border_width_bottom = 2
	normal_stylebox.border_color = Color("#0c5928")
	button.add_theme_stylebox_override("normal", normal_stylebox)
	button.add_theme_stylebox_override("disabled", normal_stylebox)
	
	var hover_stylebox := StyleBoxFlat.new()
	hover_stylebox.bg_color = Color("#d7e9d8")
	button.add_theme_stylebox_override("hover", hover_stylebox)
	
	var pressed_stylebox := StyleBoxFlat.new()
	pressed_stylebox.bg_color = colors[0]
	button.add_theme_stylebox_override("pressed", pressed_stylebox)
	
	button.toggle_mode = true
	button.custom_minimum_size = Vector2(42, 42)
	
	button.set_meta("state", CellState.EMPTY)
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_on_button_pressed.bind(button, row, column))
	button.disabled = true
	
	grid.add_child(button)
	return button

func create_number(row: int, column: int):
	var number := Label.new()
	number.text = str(paint_clues[row][column] + 1)
	number.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	number.add_theme_color_override("font_color", Color("44664ac8"))
	number.add_theme_font_size_override("font_size", 22)
	number.custom_minimum_size = Vector2(42, 42)
	number.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	number_grid.add_child(number)
	return number

func create_color_button(index: int):
	var color_rect := Button.new()
	var normal_stylebox := StyleBoxFlat.new()
	normal_stylebox.bg_color = colors[index]
	normal_stylebox.border_width_left = 2
	normal_stylebox.border_width_right = 2
	normal_stylebox.border_width_top = 2
	normal_stylebox.border_width_bottom = 2
	normal_stylebox.border_color = Color("BLACK")
	color_rect.add_theme_stylebox_override("normal", normal_stylebox)
	color_rect.add_theme_stylebox_override("hover", normal_stylebox)
	
	var pressed_stylebox := StyleBoxFlat.new()
	pressed_stylebox.bg_color = normal_stylebox.bg_color
	pressed_stylebox.border_width_left = 2
	pressed_stylebox.border_width_right = 2
	pressed_stylebox.border_width_top = 2
	pressed_stylebox.border_width_bottom = 2
	pressed_stylebox.border_color = Color("GRAY")
	color_rect.add_theme_stylebox_override("pressed", pressed_stylebox) 
	
	color_rect.focus_mode = Control.FOCUS_NONE
	color_rect.toggle_mode = true
	color_rect.custom_minimum_size = Vector2(42, 42)
	
	var color_number := Label.new()
	color_number.text = str(index + 1)
	color_number.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	color_number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	color_number.add_theme_color_override("font_color", Color("BLACK"))
	color_number.add_theme_font_size_override("font_size", 22)
	color_number.custom_minimum_size = Vector2(42, 42)
	color_number.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	color_rect.pressed.connect(_on_color_pressed.bind(color_rect, index))
	
	color_grid.add_child(color_rect)
	color_num_grid.add_child(color_number)

func _on_button_pressed(button: Button, row: int, column: int):
	var current_stylebox: StyleBoxFlat = button.get_theme_stylebox("pressed")
	current_stylebox.bg_color = current_color
	button.add_theme_stylebox_override("pressed", current_stylebox)
	button.add_theme_stylebox_override("disabled", current_stylebox)
	button.disabled = true
	button.set_meta("state", CellState.FILLED)
	
	var index = (column * grid_size) + row
	var grid_nums = number_grid.get_children()
	grid_nums[index].add_theme_color_override("font_color", current_color)
	
	check_grid()

func _on_color_pressed(button: Button, number: int):	
	for other_button in color_squares:
		if other_button != button and other_button.is_pressed() == true:
			other_button.button_pressed = false
	
	current_color = button.get_theme_stylebox("normal").bg_color
	current_number = number
	
	var grid_buttons = grid.get_children()
	var grid_nums = number_grid.get_children()
	
	# check which buttons in the main grid correspond to the current color selected
	for row in range(grid_size):
		for column in range(grid_size):
			var index = (row * grid_size) + column
			var target_button = grid_buttons[index]
			
			if target_button.get_meta("state") == CellState.FILLED:
				continue
			if paint_clues[column][row] == number:
				target_button.disabled = false
				grid_nums[index].add_theme_color_override("font_color", Color("#0c5928"))
			else:
				target_button.disabled = true
				grid_nums[index].add_theme_color_override("font_color", Color("44664ac8"))
	
	check_paint_status(current_color, current_number)

func check_grid():
	var buttons = grid.get_children()
	var check_counter := 0
	
	for row in range(grid_size):
		for column in range(grid_size):
			var index = (row * grid_size) + column
			var target_button = buttons[index]
			if target_button.get_meta("state") == CellState.FILLED:
				check_counter += 1
			elif target_button.get_meta("state") == CellState.EMPTY:
				continue
	
	if check_counter == (grid_size * grid_size):
		paint_by_number_solved.emit()

func check_paint_status(color: Color, color_number: int):
	var total = 0
	var current_counter := 0
	var grid_array = grid.get_children()
	
	for column in paint_clues:
		for num in column:
			if num == color_number:
				total += 1
	
	for cell in grid_array:
		if cell.get_meta("state") == CellState.FILLED:
			var cell_color = cell.get_theme_stylebox("pressed").bg_color
			if cell_color == color:
				current_counter += 1
	
	print(total, " versus ", current_counter)
	
	if total == current_counter:
		var current_color_num = color_num_grid.get_child(color_number)
		current_color_num.add_theme_color_override("font_color", Color("#44664ac8"))
