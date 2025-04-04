extends Object
class_name Instruction

var instruction: Callable
var parameters: Array

func _init(_instruction: Callable, _parameters: Array = []):
	self.instruction = _instruction
	self.parameters = _parameters

func execute():
	return await instruction.call(parameters)
