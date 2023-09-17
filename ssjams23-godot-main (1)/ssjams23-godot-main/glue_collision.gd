class_name GlueCollision

var last_collid_points: PackedVector2Array
var last_collid_points_orig: PackedVector2Array
var last_collid_points_diff: Array
const MAX_GLUE_DIST = 40
var last_pos = Vector2()
var last_rot = 0.0

func add_collid_point(pos: Vector2, global_position: Vector2, rotation: float):
	for p in last_collid_points:
		if (p - pos).length() < 5:
			return
	last_collid_points.append(pos)
	last_collid_points_orig.append(pos)
	last_collid_points_diff.append(0)

func update_last_collid_points(global_position: Vector2, rotation: float):
	var delta_move = global_position - last_pos
	var delta_rot = rotation - last_rot
	if delta_move.length() != 0 or delta_rot != 0:
		for i in range(last_collid_points.size() - 1, -1, -1):
			var ind = last_collid_points[i]
			ind -= global_position
			ind = ind.rotated(delta_rot-rotation)
			ind = ind.rotated(rotation)
			ind += global_position + delta_move
			last_collid_points[i] = ind
			
			last_collid_points_diff[i] = (last_collid_points[i] - last_collid_points_orig[i]).length()
			if last_collid_points_diff[i] > MAX_GLUE_DIST:
				last_collid_points_diff.remove_at(i)
				last_collid_points.remove_at(i)
				last_collid_points_orig.remove_at(i)
			
		last_pos = global_position
		last_rot = rotation

func draw_collisions(draw_func, global_position: Vector2, rotation: float):
	for i in range(last_collid_points.size()):
		var ind = last_collid_points[i]
		var ind_orig = last_collid_points_orig[i]
		
		var distance = last_collid_points_diff[i]
		var mult = (1 - pow(distance / MAX_GLUE_DIST,2))
		
		var local_position = ind - global_position
		local_position = local_position.rotated(-rotation) # Note the negative rotation to transform it to the local space
		draw_func.draw_circle(local_position, 10 * mult, Color(255,255,255))

		var local_position_orig = ind_orig - global_position
		local_position_orig = local_position_orig.rotated(-rotation) # Note the negative rotation to transform it to the local space
		draw_func.draw_circle(local_position_orig, 10 * mult, Color(255,255,255))
		
		var thickness = 5 * mult + 0.1
		draw_func.draw_line(local_position, local_position_orig, Color(255,255,255), thickness)
