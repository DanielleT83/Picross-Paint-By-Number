extends Control

@onready var grid = $CenterContainer/Grid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.setup_puzzle(Global.current_level_data)
	grid.init_game()
	grid.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")
