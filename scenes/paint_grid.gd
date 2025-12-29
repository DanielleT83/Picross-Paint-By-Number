extends Control

@onready var grid:GridContainer = $GridContainer
@onready var number_grid:GridContainer = $GridContainer2
@onready var color_grid:GridContainer = $GridContainer3
@onready var color_num_grid:GridContainer = $GridContainer4
enum CellState {EMPTY, FILLED}


var grid_size: int
var colors: Array
var paint_clues: Array
var game_grid = []
var num_grid = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup_puzzle(level_data: LevelData):
	grid_size = level_data.grid_width
	colors = level_data.colors
	paint_clues = level_data.paint_clues

func init_game():
	grid.columns = grid_size
	number_grid.columns = grid_size
	number_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_grid.columns = len(colors)
	color_num_grid.columns = len(colors)
	color_num_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_populate_grid()
	
	custom_minimum_size = Vector2(grid_size * 42, grid_size * 42)

func _populate_grid():
	#creating the grid squares (buttons) 
	game_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_button())
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
		
		
		

func create_button():
	var button := Button.new()
	
	var normal_stylebox := StyleBoxFlat.new()
	normal_stylebox.bg_color = Color("#d7e9d8")
	normal_stylebox.border_width_left = 2
	normal_stylebox.border_width_right = 2
	normal_stylebox.border_width_top = 2
	normal_stylebox.border_width_bottom = 2
	normal_stylebox.border_color = Color("#0c5928")
	button.add_theme_stylebox_override("normal", normal_stylebox)
	
	
	var hover_stylebox := StyleBoxFlat.new()
	hover_stylebox.bg_color = Color("#d7e9d8")
	button.add_theme_stylebox_override("hover", hover_stylebox)
	
	var pressed_stylebox := StyleBoxFlat.new()
	pressed_stylebox.bg_color = colors[0]
	button.add_theme_stylebox_override("pressed", pressed_stylebox)
	
	button.toggle_mode = true
	button.custom_minimum_size = Vector2(42, 42)
	
	button.set_meta("state", CellState.EMPTY)
	
	button.pressed.connect(_on_button_pressed.bind(button))
	
	grid.add_child(button)
	return button

func create_number(row: int, column: int):
	var number := Label.new()
	number.text = str(paint_clues[row][column] + 1)
	number.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	number.add_theme_color_override("font_color", Color("#0c5928"))
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
	
	var hover_stylebox := StyleBoxFlat.new()
	hover_stylebox.bg_color = colors[index]
	hover_stylebox.border_width_left = 2
	hover_stylebox.border_width_right = 2
	hover_stylebox.border_width_top = 2
	hover_stylebox.border_width_bottom = 2
	hover_stylebox.border_color = Color("BLACK")
	color_rect.add_theme_stylebox_override("hover", hover_stylebox)
	
	var pressed_stylebox := StyleBoxFlat.new()
	pressed_stylebox.bg_color = normal_stylebox.bg_color
	pressed_stylebox.border_width_left = 2
	pressed_stylebox.border_width_right = 2
	pressed_stylebox.border_width_top = 2
	pressed_stylebox.border_width_bottom = 2
	pressed_stylebox.border_color = Color("GRAY")
	color_rect.add_theme_stylebox_override("pressed", pressed_stylebox) 
	
	color_rect.toggle_mode = true
	color_rect.custom_minimum_size = Vector2(42, 42)
	
	color_rect.pressed.connect(_on_color_pressed.bind(color_rect))
	
	var color_number := Label.new()
	color_number.text = str(index + 1)
	color_number.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	color_number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	color_number.add_theme_color_override("font_color", Color("BLACK"))
	color_number.add_theme_font_size_override("font_size", 22)
	color_number.custom_minimum_size = Vector2(42, 42)
	color_number.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	color_grid.add_child(color_rect)
	color_num_grid.add_child(color_number)

func _on_button_pressed(button: Button):
	#button.texture_pressed = preload("res://assets/tile_filled.png")
	button.set_meta("state", CellState.FILLED)

func _on_color_pressed(_button: Button):
	pass
