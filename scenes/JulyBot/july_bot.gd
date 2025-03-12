extends CharacterBody2D

@export var GRID_SNAP = 160
@export var SPEED = 5.0

func _ready() -> void:
	$Timer.start()

func parse(code_string):
	var code_block: Array[Instruction]
	for line in code_string:
		if line[0] == "for":
			code_block.append(For.new(callable_for, parse(line[1]), line[2], line[3], line[4]))
		#
		#elif line[0] == "while":
			#code_block.append(While.new(callable_while, parse(line[1]), line[2]))
		#
		elif line[0] == "water":
			code_block.append(Instruction.new(callable_water))
		elif line[0] == "left":
			code_block.append(Instruction.new(callable_move_left))
		elif line[0] == "right":
			code_block.append(Instruction.new(callable_move_right))
		elif line[0] == "up":
			code_block.append(Instruction.new(callable_move_up))
		elif line[0] == "down":
			code_block.append(Instruction.new(callable_move_down))
	return code_block

func callable_move_left(executed_signal: Signal):
	for n in range(0, 32, 1):
		position.x -= SPEED
	await get_tree().create_timer(1.0).timeout
	executed_signal.emit()
	
func callable_move_right(executed_signal: Signal):
	for n in range(0, 32, 1):
		print("right", n)
		position.x += SPEED
	await get_tree().create_timer(1.0).timeout
	executed_signal.emit()
	
func callable_move_up(executed_signal: Signal):
	for n in range(0, 32, 1):
		position.y -= SPEED
	await get_tree().create_timer(1.0).timeout
	executed_signal.emit()
	
func callable_move_down(executed_signal: Signal):
	for n in range(0, 32, 1):
		print("down", n)
		position.y += SPEED
	await get_tree().create_timer(1.0).timeout
	executed_signal.emit()
	
func callable_water(executed_signal: Signal):
	print("water")
	await get_tree().create_timer(1.0).timeout
	executed_signal.emit()

func callable_for(executed_signal: Signal, code_block: Array[Instruction], start: int, end: int, increment: int):
	for n in range(start, end, increment):
		for line in code_block:
			line.execute()
			await line.executed
	executed_signal.emit()
		
func callable_while(executed_signal: Signal, code_block: Array[Instruction], condition: bool):
	while(condition):
		for line in code_block:
			line.execute()
			await line.executed
	executed_signal.emit()

func callable_function(executed_signal: Signal, code_block: Array[Instruction]):
	for line in code_block:
		line.execute()
		await line.executed
	executed_signal.emit()

func run_code():
	print("compiling...")
	var code_block = parse([["for", [["right"]], 0, 3, 1],["water"],
		["for", [["up"]], 0, 2, 1], ["for", [["left"]], 0, 4, 1]])
	var code = Fuction.new(callable_function, code_block)
	print("executing...")
	code.execute()
	await code.executed
	print("done")

func _on_timer_timeout():
	run_code()
