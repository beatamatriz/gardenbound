extends Function
class_name While

var condition: Instruction

func _init(_instruction: Callable, _condition: Instruction, _code_block: Array[Instruction]):
	self.instruction = _instruction
	self.code_block = _code_block
	self.condition = _condition

func execute():
	await instruction.call(code_block, condition)
