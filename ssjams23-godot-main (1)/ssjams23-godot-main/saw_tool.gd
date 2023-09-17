extends Node2D

var saw_state = "idle"
var saw_start_point: Vector2
var saw_end_point: Vector2

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if saw_state == "powered_up":
		pass
		

func do_cut():
	
	for ob in $Area2D.get_overlapping_bodies():
		if ob is Draggable:
			ob.split(saw_start_point, saw_end_point)
		
	$Area2D.monitoring = false

func _input(event):
	if saw_state:
		queue_redraw()
		if event is InputEventMouseMotion:
			saw_end_point = event.global_position
			$Area2D/CollisionShape2D.shape.b = saw_end_point - global_position

		elif event is InputEventMouseButton && !event.pressed and saw_state == "measuring":
			print_debug("DONE")
			saw_state = ""
			saw_end_point = event.global_position
			$Area2D/CollisionShape2D.shape.b = saw_end_point - global_position
			do_cut()
			
		elif event is InputEventMouseButton && event.pressed:
			print_debug("STARTING...")
			saw_state = "measuring"
			saw_start_point = event.global_position
			$Area2D.monitoring = true
			$Area2D/CollisionShape2D.shape.a = saw_start_point - global_position
			
func _on_button_button_down():
	saw_state = "powered_up"
	set_process_input(true)

func _draw():
	if saw_state == "measuring":
		draw_line(saw_start_point - global_position, saw_end_point - global_position, Color(0,255,0), 10)
