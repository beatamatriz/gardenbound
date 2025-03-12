extends Instruction
class_name Fuction

var code_block: Array[Instruction]

func _init(_instruction: Callable, _code_block: Array[Instruction]):
	self.instruction = _instruction
	self.code_block = _code_block

func execute():
	instruction.call(executed, code_block)
