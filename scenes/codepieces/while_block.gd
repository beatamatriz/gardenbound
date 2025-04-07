extends VBoxContainer

@onready var code_block = $Body/CodeBlockBox
@onready var conditional = $Head/Limb

@export var control_name: Syntax.InstructionName

var inside_conditional = false

func get_code():
	var code = []
	for line in code_block.get_children():
		code.append(line.get_code())
	return [control_name, conditional.get_children()[-1].get_code(), code]

func create_preview():
	return self.duplicate(2)

func create_data():
	return [self, false]

func _get_drag_data(at_position):
	var prev = create_preview()
	set_drag_preview(prev)
	return create_data()

func _can_drop_data(at_position, data):
	# TODO: highlight
	if self != data[0]:
		if inside_conditional:
			return data[1]
		else:
			return not data[1]
	return false

func _drop_data(at_position, data):
	data[0].get_parent().remove_child(data[0])
	if inside_conditional:
		conditional.add_child(data[0])
	else:
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

func _on_conditional_mouse_entered():
	inside_conditional = true

func _on_conditional_mouse_exited():
	inside_conditional = false
