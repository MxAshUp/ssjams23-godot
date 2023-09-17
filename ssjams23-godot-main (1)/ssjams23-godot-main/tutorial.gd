extends Node2D




func _on_texture_button_pressed():
	$Text4/butttonfx.play()
	get_tree().change_scene_to_file("res://editor.tscn")
