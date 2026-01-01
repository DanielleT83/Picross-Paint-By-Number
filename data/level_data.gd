extends Resource
class_name LevelData

@export var grid_width: int
@export var grid_height: int
@export var solution: Array #by row
@export var row_clues: Array
@export var column_clues: Array
@export var paint_clues: Array #by column
@export var colors: Array
@export var title: String

#@export var initialize_solution_button := false:
	#set(value):
		#if value:
			#initialize_solution()
			#initialize_solution_button = false
#
#func initialize_solution():
	#solution.clear()
	#for y in range(grid_height):
		#var row := []
		#for x in range(grid_width):
			#row.append(0)
		#solution.append(row)
