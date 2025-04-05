extends CharacterBody2D

@export var GRID_SNAP = 160
@export var SPEED = 5.0

var functions: Dictionary # I need to clear this in each run

func _ready() -> void:
	$RunOffset.start()

func callable_if(condition: Instruction, then_code_block: Array[Instruction], else_code_block: Array[Instruction]) -> void:
	if await condition.execute():
		for line in then_code_block:
			await line.execute()
	else:
		for line in else_code_block:
			await line.execute()

func callable_for(start: int, end: int, increment: int,code_block: Array[Instruction]) -> void:
	for n in range(start, end, increment):
		for line in code_block:
			await line.execute()

func callable_while(code_block: Array[Instruction], condition: Instruction) -> void:
	while(await condition.execute()):
		for line in code_block:
			await line.execute()

func callable_function(parameters: Array, code_block: Array[Instruction]) -> void:
	for line in code_block:
		await line.execute()

# Atomic Instructions
func callable_move_left(parameters) -> void:
	print("moving left")
	for n in range(0, 32, 1):
		position.x -= SPEED
func callable_move_right(parameters) -> void:
	print("moving right")
	for n in range(0, 32, 1):
		position.x += SPEED
func callable_move_up(parameters) -> void:
	print("moving up")
	for n in range(0, 32, 1):
		position.y -= SPEED
func callable_move_down(parameters) -> void:
	print("moving down")
	for n in range(0, 32, 1):
		position.y += SPEED
func callable_water(parameters) -> void:
	print("water")
func callable_wait(parameters) -> void:
	$Wait.start(parameters[0])
	print("waiting ", parameters[0], " seconds")
	await $Wait.timeout
func callable_is_on_white(parameters) -> bool:
	return snappedi(position.x, 160)/160 % 2 == 0 and snappedi(position.y, 160)/160 % 2 == 0

# Pseudo Compiler
func parse(code_string: Array) -> Array[Instruction]:
	var code_block: Array[Instruction]
	for line in code_string:
		if line[0] == Syntax.InstructionName.FUNCTION_DEFINE:
			functions.get_or_add(line[1], [line[2], line[3]])
		elif line[0] == Syntax.InstructionName.FUNCTION_CALL:
			pass # Vamos a no preocuparnos ahora mismo
		elif line[0] == Syntax.InstructionName.IF:
			code_block.append(If.new(callable_if, parse([line[1]])[0], parse(line[2]), parse(line[3])))
		elif line[0] == Syntax.InstructionName.FOR:
			code_block.append(For.new(callable_for, line[1], line[2], line[3], parse(line[4])))
		elif line[0] == Syntax.InstructionName.WHILE:
			code_block.append(While.new(callable_while, parse([line[1]])[0], parse(line[2])))
		elif line[0] == Syntax.InstructionName.WATER:
			code_block.append(Instruction.new(callable_water,[]))
		elif line[0] == Syntax.InstructionName.MOVE_LEFT:
			code_block.append(Instruction.new(callable_move_left, []))
		elif line[0] == Syntax.InstructionName.MOVE_RIGHT:
			code_block.append(Instruction.new(callable_move_right, []))
		elif line[0] == Syntax.InstructionName.MOVE_UP:
			code_block.append(Instruction.new(callable_move_up, []))
		elif line[0] == Syntax.InstructionName.MOVE_DOWN:
			code_block.append(Instruction.new(callable_move_down, []))
		elif line[0] == Syntax.InstructionName.WAIT:
			code_block.append(Instruction.new(callable_wait, line[1]))
		elif line[0] == Syntax.InstructionName.IS_ON_WHITE:
			code_block.append(Instruction.new(callable_is_on_white, []))
			
	return code_block

func run_code(code: Array) -> void:
	print("compiling...")
	var code_block = parse(code)
	var program = Function.new(callable_function, code_block)
	print("executing...")
	await program.execute()
	print("done")
