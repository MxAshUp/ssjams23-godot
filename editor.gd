extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		var new_junnk: Draggable = $all_junk.crete_junk()
		$junk_container.add_child(new_junnk)
		new_junnk.position = Vector2(randi_range(0,800),randi_range(0,600))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
