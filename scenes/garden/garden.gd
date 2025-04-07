extends Node3D

@onready var july_bot = $JulyBot

func _on_code_start_run_code(code):
	july_bot.run_code(code)


func _on_rotate_left_2_gui_input(event):
	pass # Replace with function body.
