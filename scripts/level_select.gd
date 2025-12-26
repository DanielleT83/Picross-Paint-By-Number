extends Control

@onready var grid:GridContainer = $GridContainer

const grid_length = 3
const grid_height = 2
var levels_grid = []

var level_num_counter = 1

var level_button_size = 210


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func init_grid():
	grid.columns = grid_length
	var level_select_grid = []
	
	for i in range(grid_height):
		var row = []
		for x in range(grid_length):
			row.append(create_button(Vector2(i, x)))
		level_select_grid.append(row)

func create_button(pos:Vector2):
	var button = TextureButton.new()
	button.position = pos
	button.texture_normal = preload("res://assets/tile_empty.png")
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.custom_minimum_size = Vector2(level_button_size, level_button_size)
	
	var button_num = Label.new()
	
	button_num.position = pos
	button_num.size.x = level_button_size
	button_num.size.y = level_button_size
	button_num.text = str(level_num_counter)
	button_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button_num.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	button_num.add_theme_font_size_override("font_size", 100)
	button_num.add_theme_color_override("font_color", Color.DARK_GREEN)
	
	button.pressed.connect(_on_button_pressed.bind(level_num_counter))

	button.add_child(button_num)
	grid.add_child(button)
	
	level_num_counter += 1
	return button
	

func _on_button_pressed(_level: int):
	
	get_tree().change_scene_to_file("res://scenes/level.tscn")
