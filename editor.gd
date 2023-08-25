extends Node2D


var money = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$junk_selector.connect("new_draggable", place_draggable)

func place_draggable(new_junnk: Draggable):
	$junk_container.add_child(new_junnk)
	new_junnk.start_drag(new_junnk.position)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func delta_money(amount):
	money += amount
	$money_label.text = "Money: $" + str(amount)

func super_drag():
	for junk in $junk_container.get_children():
		if junk is Draggable:
			junk.start_drag(junk.position)

func _on_color_picker_button_color_changed(color):
	$ColorRect.color = color


func _on_color_picker_button_2_color_changed(color):
	for dragSpr in $junk_container.get_children():
		if dragSpr is Draggable:
			dragSpr.set_color(color)



func _on_button_pressed():
	var value = 5
	for dragSpr in $junk_container.get_children():
		if dragSpr is Draggable:
			value += dragSpr.value
			dragSpr.queue_free()
	delta_money(randi_range(5, value))


func _on_button_2_pressed():
	await RenderingServer.frame_post_draw
	var image = get_viewport().get_texture().get_image().get_region(Rect2i($screenshot_rect.position, $screenshot_rect.size))
	image.save_png("res://my-art.png")
	for dragSpr in $junk_container.get_children():
		if dragSpr is Draggable:
			dragSpr.queue_free()
