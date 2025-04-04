extends Function

class_name If

var else_code_block: Array[Instruction]
var condition: Instruction

func _init(_instruction: Callable, _condition: Instruction, _if_code_block: Array[Instruction], _else_code_block: Array[Instruction]):
	self.instruction = _instruction
	self.condition = _condition
	self.code_block = _if_code_block
	self.else_code_block = _else_code_block

func execute():
	return await instruction.call(condition, code_block, else_code_block)
