extends Node

enum InstructionName{FUNCTION_DEFINE, FUNCTION_CALL, IF, WHILE, FOR, WATER,
	MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, WAIT, IS_ON_WHITE}

func instruction_name_to_string(instruction_name: InstructionName):
	if instruction_name == InstructionName.WATER:
		return "water()"
	if instruction_name == InstructionName.WAIT:
		return "wait()"
	if instruction_name == InstructionName.MOVE_LEFT:
		return "move_left()"
	if instruction_name == InstructionName.MOVE_RIGHT:
		return "move_right()"
	if instruction_name == InstructionName.MOVE_UP:
		return "move_up()"
	if instruction_name == InstructionName.MOVE_DOWN:
		return "move_down()"
	if instruction_name == InstructionName.IS_ON_WHITE:
		return "is_on_white()"
