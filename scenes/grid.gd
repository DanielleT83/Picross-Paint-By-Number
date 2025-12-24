extends Node2D

@onready var grid:GridContainer = $GridContainer

const grid_size = 15
var game_grid = []

var selected_button:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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

func create_button(pos:Vector2):
	var button = TextureButton.new()
	button.toggle_mode = true
	button.texture_normal = preload("res://assets/tile_empty.png")
	button.texture_pressed = preload("res://assets/tile_filled.png")
	#button.expand_icon = true
	button.custom_minimum_size = Vector2(42, 42)
	
	button.pressed.connect(_on_button_pressed.bind(pos))
	
	grid.add_child(button)
	return button

func _on_button_pressed(pos: Vector2):
	
	selected_button = pos
