extends VBoxContainer

@onready var code_block = $CodeBlockBox
@onready var run_button = $Header/StartShoulder/RunButton

signal run_code

func get_code():
	var code = []
	for line in code_block.get_children():
		code.append(line.get_code())
	return code
	
func _can_drop_data(at_position, data):
	if self != data[0]:
		return not data[1]
	return false

func _drop_data(at_position, data):
	data[0].get_parent().remove_child(data[0])
	var nearest_child_index = find_nearest_child(get_viewport().get_mouse_position())
	code_block.add_child(data[0])
	code_block.move_child(data[0], nearest_child_index)

func find_nearest_child(pos: Vector2):
	var children = code_block.get_children()
	if children:
		for child in children:
			if pos.y < child.global_position.y:
				return child.get_index()
		return children.size()
	else:
		return 0


func _on_texture_button_pressed():
	# TODO: Check code syntax
	run_button.disabled = true
	var code = self.get_code()
	emit_signal("run_code", code)
	pass # Replace with function body.
