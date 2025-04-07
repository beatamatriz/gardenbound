extends CharacterBody3D

@export var game_speed_scalar = 1.0

@onready var head = $Head
@onready var action_timer = $ActionTimer
@onready var wait_timer = $WaitTimer
@onready var direction = Vector3.BACK

signal my_signal

const DEFAULT_SPEED = 30.0
const DEFAULT_ROTATION_SPEED = PI/2

var speed = 0.0
var rotation_speed = 0.0
var functions: Dictionary # I need to clear this in each run
var nearest_pot_direction = Vector3.ZERO
var current_pot: Node3D
var flower_count = 0

func _physics_process(delta):
	if speed != 0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		position += velocity * delta * game_speed_scalar
	else:
		velocity = Vector3.ZERO
	if rotation_speed != 0.0:
		rotate_y(rotation_speed * delta * game_speed_scalar)

func _ready() -> void:
	position = position.snapped(Vector3.ONE * DEFAULT_SPEED)
	rotation = rotation.snapped(Vector3.ONE * DEFAULT_ROTATION_SPEED)
	
# CALLABLE FUNCTIONS:	
# Each Callable function is used to instanciate an Instruction object

# Control Structures
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
func callable_wait(parameters) -> void:
	wait_timer.start(parameters[0] / game_speed_scalar)
	print("waiting ", parameters[0], " seconds")
	await wait_timer.timeout

func callable_move(parameters) -> void:
	speed = DEFAULT_SPEED
	action_timer.start(1/game_speed_scalar)
	await action_timer.timeout
	position = position.snapped(Vector3.ONE * DEFAULT_SPEED)
	speed = 0.0

func callable_rotate_left(parameters) -> void:
	rotation_speed = DEFAULT_ROTATION_SPEED
	action_timer.start(1/game_speed_scalar)
	await action_timer.timeout
	rotation = rotation.snapped(Vector3.ONE * DEFAULT_ROTATION_SPEED)
	rotation_speed = 0.0
	direction = direction.rotated(Vector3.UP, DEFAULT_ROTATION_SPEED)
	
func callable_rotate_right(parameters) -> void:
	rotation_speed = -DEFAULT_ROTATION_SPEED
	action_timer.start(1/game_speed_scalar)
	await action_timer.timeout
	rotation = rotation.snapped(Vector3.ONE * DEFAULT_ROTATION_SPEED)
	rotation_speed = 0.0
	direction = direction.rotated(Vector3.UP, -DEFAULT_ROTATION_SPEED)

# Plant seeds in the pot directly in front of JulyBot
func callable_plant(parameters) -> void:
	if current_pot and callable_is_in_front_of_pot([]):
		current_pot.plant()

# Water the pot directly in front of JulyBot
func callable_water(parameters) -> void:
	if current_pot and callable_is_in_front_of_pot([]):
		current_pot.water()

# Harvest flowers in pot directly in front of JulyBot
func callable_harvest(parameters) -> void:
	if current_pot and callable_is_in_front_of_pot([]):
		current_pot.harvest()
		flower_count += 1

func callable_assemble_bouquet(parameters) -> void:
	if flower_count == 3:
		print("OLEEEEEEE")

# Sensors (Returns a boolean value)

# Checks if July is in front of a Flower Pot
func callable_is_in_front_of_pot(parameters) -> bool:
	return direction.is_equal_approx(nearest_pot_direction)

func callable_true(parameters) -> bool:
	return true

func callable_false(parameters) -> bool:
	return false

func set_current_pot(pot: Node3D) -> void:
	current_pot = pot

func set_nearest_pot_direction(new_direction) -> void:
	nearest_pot_direction = new_direction

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
		elif line[0] == Syntax.InstructionName.PLANT:
			code_block.append(Instruction.new(callable_plant,[]))
		elif line[0] == Syntax.InstructionName.WATER:
			code_block.append(Instruction.new(callable_water,[]))
		elif line[0] == Syntax.InstructionName.HARVEST:
			code_block.append(Instruction.new(callable_harvest,[]))
		elif line[0] == Syntax.InstructionName.ASSEMBLE_BOUQUET:
			code_block.append(Instruction.new(callable_assemble_bouquet,[]))
		elif line[0] == Syntax.InstructionName.MOVE:
			code_block.append(Instruction.new(callable_move, []))
		elif line[0] == Syntax.InstructionName.ROTATE_LEFT:
			code_block.append(Instruction.new(callable_rotate_left, []))
		elif line[0] == Syntax.InstructionName.ROTATE_RIGHT:
			code_block.append(Instruction.new(callable_rotate_right, []))
		elif line[0] == Syntax.InstructionName.WAIT:
			code_block.append(Instruction.new(callable_wait, line[1]))
		elif line[0] == Syntax.InstructionName.IS_IN_FRONT_OF_POT:
			code_block.append(Instruction.new(callable_is_in_front_of_pot, []))
		elif line[0] == Syntax.InstructionName.TRUE:
			code_block.append(Instruction.new(callable_true, []))
		elif line[0] == Syntax.InstructionName.FALSE:
			code_block.append(Instruction.new(callable_false, []))
			
	return code_block

func run_code(code: Array) -> void:
	print("compiling...")
	var code_block = parse(code)
	var program = Function.new(callable_function, code_block)
	print("executing...")
	await program.execute()
	print("done")
