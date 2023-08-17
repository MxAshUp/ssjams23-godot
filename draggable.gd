extends CharacterBody2D

class_name Draggable

var is_being_dragged = false
var draw_click_offset = Vector2()
var move_to = Vector2()
var needs_move = false
var rotation_animate_current = rotation
var rotation_animate_frame = 0
const ROTATION_ANIMATE_FRAMES = 0.1
const ROTATE_INCREMENT = PI / 4
var theSprite: Sprite2D
var theClickArea: Area2D

var collision_drawer := GlueCollision.new()

func _init(spriteWithShape: Sprite2D):
	theSprite = spriteWithShape
	var shape: CollisionPolygon2D = theSprite.get_child(0)
	theSprite.remove_child(shape)
	add_child(theSprite)
	theClickArea = Area2D.new()
	theClickArea.add_child(shape)
	add_child(shape.duplicate())
	add_child(theClickArea)
	theClickArea.connect("input_event", _on_area_2d_input_event)
	
	theSprite.position = Vector2(0,0)
	theClickArea.position = Vector2(0,0)
#	self.set_collision_layer_value(3, false)
#	self.set_collision_mask_value(3, false)
	set_col_layer(1)

func set_col_layer(lay: int):
	self.set_collision_layer(0)
	self.set_collision_mask(0)
	self.set_collision_layer_value(lay,true)
	self.set_collision_mask_value(lay,true)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)

func start_rotate(amount, delta):
	rotation += amount
	rotation_animate_frame += delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if needs_move:
		var dir_vec = move_to - self.global_position
		velocity = dir_vec * 20
		velocity.limit_length(5)
		
		#last_collid_points.clear()
		if move_and_slide():
			for ind in get_slide_collision_count():
				collision_drawer.add_collid_point(get_slide_collision(ind).get_position(), global_position, rotation)
		
	if is_being_dragged and rotation_animate_frame == 0:
		if Input.is_action_just_pressed("rotate_ccw"):
			start_rotate(-ROTATE_INCREMENT, delta)
		elif Input.is_action_just_pressed("rotate_cw"):
			start_rotate(ROTATE_INCREMENT, delta)

	if rotation_animate_frame > 0:
		# noe: 1-pow(1- is a like an inverse pow thing for style
		var aniate_rot = lerp_angle(rotation_animate_current, rotation, 1-pow(1-(rotation_animate_frame / ROTATION_ANIMATE_FRAMES), 2))
		rotation_animate_frame += delta
		theSprite.rotation = aniate_rot - rotation
		if rotation_animate_frame >= ROTATION_ANIMATE_FRAMES:
			rotation_animate_frame = 0
			rotation_animate_current = rotation
			theSprite.rotation = 0
	
	collision_drawer.update_last_collid_points(global_position, rotation)
	queue_redraw()

func _input(event):
	if is_being_dragged:
		if event is InputEventMouseMotion:
			move_to = event.global_position - draw_click_offset
			needs_move = true

		elif event is InputEventMouseButton && !event.pressed:
			theSprite.scale = Vector2(1,1)
			is_being_dragged = false
			needs_move = false
			set_process_input(false)
			
func _on_area_2d_input_event(viewport, event, shape_idx):
	# Check for a mouse button press on the object
	if event is InputEventMouseButton:
		if !is_being_dragged && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			theSprite.scale = Vector2(1.1,1.1)
			is_being_dragged = true
			draw_click_offset = event.position - self.global_position
			set_process_input(true)

func _draw():
	if collision_drawer:
		collision_drawer.draw_collisions(self, global_position, rotation)
