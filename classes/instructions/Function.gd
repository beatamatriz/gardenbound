extends Instruction
class_name Function

var code_block: Array[Instruction]

func _init(_instruction: Callable, _code_block: Array[Instruction], _parameters: Array = []):
	self.instruction = _instruction
	self.parameters = _parameters
	self.code_block = _code_block

func execute():
	return await instruction.call(parameters, code_block)
