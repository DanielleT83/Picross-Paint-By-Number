extends Node2D

@onready var grid:GridContainer = $GridContainer

var grid_size: int
var column_clues: Array
var row_clues: Array
var puzzle_solution: Array

var game_grid = []
var puzzle_state = []

var selected_button:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#check_puzzle()

func setup_puzzle(level_data: LevelData):
	grid_size = level_data.grid_width
	column_clues = level_data.column_clues
	row_clues = level_data.row_clues
	puzzle_solution = level_data.solution

func init_game():
	grid.columns = grid_size
	_populate_grid()

func _populate_grid():
	game_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_button(Vector2(i, x)))
		game_grid.append(row)
	
	for i in range(grid_size):
		add_child(create_clue(row_clues[i], "row", i))
		add_child(create_clue(column_clues[i], "column", i))


func create_button(pos:Vector2):
	var button = TextureButton.new()
	button.toggle_mode = true
	button.texture_normal = preload("res://assets/tile_empty.png")
	button.custom_minimum_size = Vector2(42, 42)
	
	button.pressed.connect(_on_button_left_pressed.bind(button,pos))
	button.gui_input.connect(_on_button_gui_input.bind(button, pos))
	
	grid.add_child(button)
	return button

func create_clue(clue_text, clue_type:String, pos:int):
	var clue = Label.new()
	var text: String
	
	clue.add_theme_color_override("font_color", Color.LIGHT_GRAY)
	clue.add_theme_font_size_override("font_size", 20)
	
	text = str(clue_text)
	var chars_to_replace = [",", "[", "]"]
	for x in chars_to_replace:
		text = text.replace(x, "")
	
	if clue_type == "row":
		clue.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		clue.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		clue.text = text
		clue.position = Vector2(grid.position.x - 40, grid.position.y + (pos * 42) + 6)
	elif clue_type == "column":
		clue.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		clue.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		clue.text = text.replace(" ", "\n")
		clue.position = Vector2(grid.position.x + (pos * 42) + 15, grid.position.y - 65)
	
	return clue

func _on_button_left_pressed(button: TextureButton, pos: Vector2):
	button.texture_pressed = preload("res://assets/tile_filled.png")
	selected_button = pos

func _on_button_gui_input(event: InputEvent, button: TextureButton, pos: Vector2):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("right_click"):
			button.texture_pressed = preload("res://assets/tile_x.png")
			button.button_pressed = not button.button_pressed
		selected_button = pos

#check
#func check_puzzle():
	#for row in game_grid:
		#var current_row = []
		#for column in row:
			#if column.texture_pressed == "res://assets/tile_filled.png" and column.pressed == true:
				#current_row.append(1)
			#else:
				#current_row.append(0)
		#puzzle_state.append(current_row)
	#
	#var puzzle_check_counter = 1
	#
	#for index in game_grid:
		#for row in puzzle_solution:
			#if index != row:
				#break
			#else:
				#puzzle_check_counter += 1
	#
	#if puzzle_check_counter == grid_size:
		#pass
		##puzzle is solved correctly
