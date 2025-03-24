extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _get_drag_data(at_position):
	var prev = TextureRect.new()
	prev.texture = self.texture
	set_drag_preview(prev)
	return self
