extends Node3D

var planted = false
var harvestable = false

func plant():
	planted = true
	print("plant")
	
func water():
	$Rose.visible = true
	harvestable = true
	
func harvest():
	$Rose.visible = false
	harvestable = false
	planted = false
	

func _on_interaction_area_body_entered(body):
	if body.name == "JulyBot":
		body.set_current_pot(self)
		body.set_nearest_pot_direction((self.position - body.position.snapped(Vector3.ONE * body.DEFAULT_SPEED)).normalized())

func _on_interaction_area_body_exited(body):
	if body.name == "JulyBot":
		body.set_current_pot(null)
		body.set_nearest_pot_direction(Vector3.ZERO)
