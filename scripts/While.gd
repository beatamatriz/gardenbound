extends Fuction
class_name While

var condition: bool

func _init(_instruction: Callable, _code_block: Array[Instruction], _condition: bool):
	self.instruction = _instruction
	self.code_block = _code_block
	self.condition = _condition

func execute():
	instruction.call(executed, code_block, condition)
