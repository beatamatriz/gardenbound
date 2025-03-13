extends Function
class_name For

var start: int
var end: int
var increment: int

func _init(_instruction: Callable, _start: int, _end: int, _increment: int, _code_block: Array[Instruction]):
	self.instruction = _instruction
	self.code_block = _code_block
	self.start = _start
	self.end = _end
	self.increment = _increment

func execute():
	await instruction.call(start, end, increment, code_block)
