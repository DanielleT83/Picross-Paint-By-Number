extends Control

@onready var grid:GridContainer = $GridContainer

var grid_size: int
var puzzle_solution: Array
var game_grid = []

var selected_button:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup_puzzle(level_data: LevelData):
	grid_size = level_data.grid_width
	#paint_clues = level_data.solution

func init_game():
	grid.columns = grid_size
	_populate_grid()
	
	custom_minimum_size = Vector2(grid_size * 42, grid_size * 42)

func _populate_grid():
	game_grid = []
	for i in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(create_button(Vector2(i, x)))
		game_grid.append(row)


func create_button(pos:Vector2):
	var button = Button.new()
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Color("#d7e9d8")
	stylebox.border_width_left = 2
	stylebox.border_width_right = 2
	stylebox.border_width_top = 2
	stylebox.border_width_bottom = 2
	stylebox.border_color = Color("#0c5928")
	
	button.add_theme_stylebox_override("normal", stylebox)
	
	button.toggle_mode = true
	button.custom_minimum_size = Vector2(42, 42)
	
	#button.set_meta("state", CellState.EMPTY)
	
	button.pressed.connect(_on_button_left_pressed.bind(button,pos))
	button.gui_input.connect(_on_button_gui_input.bind(button, pos))
	
	grid.add_child(button)
	return button

func _on_button_left_pressed(button: TextureButton, pos: Vector2):
	button.texture_pressed = preload("res://assets/tile_filled.png")
	#button.set_meta("state", CellState.FILLED)
	selected_button = pos

func _on_button_gui_input(event: InputEvent, button: TextureButton, pos: Vector2):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("right_click"):
			button.texture_pressed = preload("res://assets/tile_x.png")
			button.button_pressed = not button.button_pressed
			#button.set_meta("state", CellState.MARKED)
		selected_button = pos
