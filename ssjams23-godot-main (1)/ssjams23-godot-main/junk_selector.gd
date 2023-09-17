extends ScrollContainer

signal new_draggable

var junk_objects: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var junk_ar = $all_junk.get_children()
	junk_ar.shuffle()
	for theSpr in junk_ar:
		if theSpr is Sprite2D:
			var text_clicker: TextureRect = $text_rect_template.duplicate()
			var textu = AtlasTexture.new()
			textu.atlas = theSpr.texture
			textu.region = theSpr.region_rect
			text_clicker.texture = textu
			text_clicker.visible = true
			text_clicker.connect("gui_input", handle_click_junk.bind(theSpr))
			$BoxContainer.add_child(text_clicker)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_click_junk(event: InputEvent, text_clicker: Sprite2D):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			create_junk(text_clicker, get_global_mouse_position())
	
func create_junk(sp: Sprite2D, pos: Vector2):
	var newSpriteWithShape = sp.duplicate()
	var junk_obj = Draggable.new(newSpriteWithShape)
	junk_obj.position = pos
	emit_signal("new_draggable", junk_obj)
