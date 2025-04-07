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
