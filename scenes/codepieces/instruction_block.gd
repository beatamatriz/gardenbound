extends HBoxContainer

@onready var label = $Shoulder/Label 

@export var instruction_name: Syntax.InstructionName

var parameters = [1]

func _ready():
	label.text = Syntax.instruction_name_to_string(instruction_name)

func get_code():
	return [instruction_name, parameters]

func create_preview():
	return self.duplicate()

func create_data():
	return [self, false]

func _get_drag_data(at_position):
	var prev = create_preview()
	set_drag_preview(prev)
	return create_data()
