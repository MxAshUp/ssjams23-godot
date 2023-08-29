extends TextureRect
var img1 = load("res://2.jpg")
var img2 = load("res://printable-full-page-graph-paper-grid_175724.jpg")
var img3 = load("res://clay bg2.jpg")
var img4 = load("res://mJlkf5.png")
var bg = 1

func _on_texture_button_pressed():
	$"../fxmain".play()
	bg += 1
	if bg == 5:
		bg = 1
	print (bg)
	if bg == 1:
		set_texture (img1)
	if bg == 2:
		set_texture (img2)
	if bg == 3:
		set_texture (img3)
	if bg == 4:
		set_texture (img4)

		
