extends Node2D

var junk_objects: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func crete_junk() -> Draggable:
	var random_j = randi_range(0, len(get_children())-1)
	var newSpriteWithShape = get_child(random_j).duplicate()
	var junk_obj = Draggable.new(newSpriteWithShape)
	return junk_obj
