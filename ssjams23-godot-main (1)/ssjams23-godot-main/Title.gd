extends Node2D



func _on_texture_button_pressed():
	$clickfx.play()
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_texture_button_2_pressed():
	$clickfx.play()
	get_tree().close()


