extends VBoxContainer

@onready var code_block = $Body/CodeBlockBox

func create_preview():
	return self.duplicate()

func create_data(pos):
	return [self, pos]

func _get_drag_data(at_position):
	var prev = create_preview()
	set_drag_preview(prev)
	return create_data(at_position)

func _can_drop_data(at_position, data):
	return self != data[0]

func _drop_data(at_position, data):
	data[0].get_parent().remove_child(data[0])
	var nearest_child = find_nearest_child(data[1])
	if nearest_child:
		nearest_child.add_sibling(data[0])
	else:
		code_block.add_child(data[0])

func find_nearest_child(pos: Vector2):
	var children = code_block.get_children()
	if children:
		var iter = 1
		var dist = pos.distance_to(children[0].position)
		while iter < children.size() and pos.distance_to(children[iter].position) < dist:
			iter += 1
		return children[iter-1]
	else:
		return null
