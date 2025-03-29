extends TextureRect

	
func create_preview():
	return self.duplicate()

func create_data(pos):
	return [self, pos]

func _get_drag_data(at_position):
	var prev = create_preview()
	set_drag_preview(prev)
	return create_data(at_position)
