extends Control

@onready var grid:GridContainer = $GridContainer
@export var level_scene: PackedScene
@export var levels: Array[LevelData]

enum LevelState {UNSOLVED, SOLVED}


const grid_length = 3
const grid_height = 2
var levels_grid = []
var level_num_counter = 1
const level_button_size = 210

var pixel_font = preload("res://assets/Tiny5-Regular.ttf")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_grid()
	
	# Change the level icon if it's been completed
	var buttons = grid.get_children()
	for level in len(levels):
		if Global.is_level_solved(levels[level].resource_path):
			buttons[level].texture_normal = levels[level].solved_image
			buttons[level].get_child(0).hide()

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
	button.texture_normal = preload("res://assets/big_button.png")
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.custom_minimum_size = Vector2(level_button_size, level_button_size)
	button.set_meta("state", LevelState.UNSOLVED)
	
	var button_num = Label.new()

	button_num.position = Vector2(pos.x + 15, pos.y)
	button_num.size.x = level_button_size
	button_num.size.y = level_button_size
	button_num.text = str(level_num_counter)
	button_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button_num.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	button_num.add_theme_font_override("font", pixel_font)
	button_num.add_theme_font_size_override("font_size", 145)
	button_num.add_theme_color_override("font_color", Color.DARK_GREEN)
	
	button.pressed.connect(_on_button_pressed.bind(level_num_counter))

	button.add_child(button_num)
	grid.add_child(button)
	
	level_num_counter += 1
	return button
	
func _on_button_pressed(level: int):
	level -= 1
	Global.current_level_data = levels[level]
	get_tree().change_scene_to_file("res://scenes/level.tscn")
