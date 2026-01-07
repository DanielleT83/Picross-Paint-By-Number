extends Node
class_name LevelManager

var current_level_data: LevelData

var solved_levels: Dictionary = {}

func mark_level_solved(level: String):
	solved_levels[level] = true

func is_level_solved(level: String):
	return solved_levels.has(level)
	
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
