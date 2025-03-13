extends Node2D

var active = false

var clickable = false
var dragging = false
var dragging_offset = 0

var original_scale = Vector2(0, 0)
var scale_multiplier = 1.1

var success_offset = 35

var locked = false

func _process(delta: float) -> void:
	if get_parent().get_parent().get_parent().active:
		if(locked):
			return
			
		if (clickable and !dragging and Input.is_action_just_pressed("click")):
			start_drag()
			
		if dragging:
			$Area.global_position = get_global_mouse_position() + dragging_offset
			if(Input.is_action_just_released("click")):
				drop()
		
func start_drag():
	$pickup.play()
	
	get_parent().get_parent().get_parent().mouse_clicked = true
	
	original_scale = $Area/Sprite.scale
	
	dragging = true;
	dragging_offset = $Area.global_position - get_global_mouse_position()
	$Area/Sprite.scale = original_scale * scale_multiplier
	
func drop():
	$drop.play()
	
	get_parent().get_parent().get_parent().mouse_clicked = false
	
	dragging = false;
	dragging_offset = 0
	$Area/Sprite.scale = original_scale
	
	#print_debug(($Area.global_position - $Objective.global_position).length())
	if(($Area/Sprite.global_position - $Objective.global_position).length() < success_offset):
		lock()
	
func lock():
	$lock.play()
	
	locked = true
	$Area/Sprite.modulate = "ffffff"
	get_parent().get_parent().get_parent().count += 1
	
func _mouse_enter() -> void:
	if(dragging or locked or get_parent().get_parent().get_parent().mouse_clicked):
		return
	
	$mouse_exit.stop()
	$mouse_enter.play()
		
	clickable = true
	$Area/Sprite.modulate = "ff8f97"
	
func _mouse_exit() -> void:
	if(dragging or locked or get_parent().get_parent().get_parent().mouse_clicked):
		return
		
	$mouse_enter.stop()
	$mouse_exit.play()
	
	clickable = false
	$Area/Sprite.modulate = "ffffff"
