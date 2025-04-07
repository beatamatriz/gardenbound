extends HBoxContainer

@export var sensor_name:Syntax.InstructionName

@onready var label = $CenterContainer/Label

func _ready():
	label.text = Syntax.instruction_name_to_string(sensor_name)

func get_code():
	return [sensor_name]

func create_preview():
	return self.duplicate()

func create_data():
	return [self, true]

func _get_drag_data(at_position):
	var prev = create_preview()
	set_drag_preview(prev)
	return create_data()
