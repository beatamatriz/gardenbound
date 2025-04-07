extends Node

enum InstructionName{FUNCTION_DEFINE, FUNCTION_CALL, IF, WHILE, FOR,
	WAIT, MOVE, ROTATE_LEFT, ROTATE_RIGHT, PLANT, WATER, HARVEST, ASSEMBLE_BOUQUET,
	IS_IN_FRONT_OF_POT, TRUE, FALSE}

func instruction_name_to_string(instruction_name: InstructionName):
	if instruction_name == InstructionName.PLANT:
		return "plant()"
	if instruction_name == InstructionName.WATER:
		return "water()"
	if instruction_name == InstructionName.HARVEST:
		return "harvest()"
	if instruction_name == InstructionName.ASSEMBLE_BOUQUET:
		return "assemble_bouquet()"
	if instruction_name == InstructionName.WAIT:
		return "wait()"
	if instruction_name == InstructionName.MOVE:
		return "move()"
	if instruction_name == InstructionName.ROTATE_LEFT:
		return "rotate_left()"
	if instruction_name == InstructionName.ROTATE_RIGHT:
		return "rotate_right()"
	if instruction_name == InstructionName.IS_IN_FRONT_OF_POT:
		return "is_in_front_of_pot()"
	if instruction_name == InstructionName.TRUE:
		return "true"
	if instruction_name == InstructionName.FALSE:
		return "false"
