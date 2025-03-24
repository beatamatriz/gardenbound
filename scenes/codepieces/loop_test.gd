extends VBoxContainer

@onready var code_block = $Body/CodeBlockBox

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_drag_data(at_position):
	var prev = VBoxContainer.new()
	prev = self
	set_drag_preview(prev)
	return self

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	data.get_parent().remove_child(data)
	code_block.add_child(data)
