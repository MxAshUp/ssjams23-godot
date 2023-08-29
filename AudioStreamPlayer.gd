extends AudioStreamPlayer





	
	


func _on_texture_button_3_pressed():
	$"../../fxmain".play()
	if stream_paused == false:
		stream_paused = true
	else:
		stream_paused = false
