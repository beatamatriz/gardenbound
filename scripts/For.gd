extends Fuction
class_name For

var start: int
var end: int
var increment: int

func _init(_instruction: Callable, _code_block: Array[Instruction], _start: int, _end: int, _increment: int):
	self.instruction = _instruction
	self.code_block = _code_block
	self.start = _start
	self.end = _end
	self.increment = _increment

func execute():
	instruction.call(executed, code_block, start, end, increment)
