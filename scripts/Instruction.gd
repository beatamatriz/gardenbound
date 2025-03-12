extends Object
class_name Instruction

var instruction: Callable
signal executed

func _init(_instruction: Callable):
	self.instruction = _instruction

func execute():
	instruction.call(executed)
