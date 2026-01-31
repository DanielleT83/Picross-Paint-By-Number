extends Control

@onready var startButton:TextureButton = $StartButton
@onready var tutButton:TextureButton = $TutorialButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TutorialScreen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")

func _on_tutorial_button_pressed() -> void:
	$TutorialScreen.show()
	startButton.disabled = true
	tutButton.disabled = true

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level select.tscn")
