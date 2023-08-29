extends RigidBody2D


func _on_area_2d_area_entered(area):
	self.position = Vector2(0,5)
