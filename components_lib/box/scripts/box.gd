tool
extends KinematicBody

export(float, 100, 1000, 0.1) var height_mm = 500 setget set_height
export(float, 100, 1000, 0.1) var width_mm = 600 setget set_width
export(float, 100, 1000, 0.1) var depth_mm = 430 setget set_depth
export(bool) var opened_top = false setget set_opened_top, get_opened_top
export(bool) var opened_bottom = false setget set_opened_bottom, get_opened_bottom


func set_height(value):
	var box = get_node_or_null("box_with_cover") as Spatial
	height_mm = value
	if box:
		box.scale.y = height_mm/500
	var collision = get_node_or_null("collision") as Spatial
	if collision:
		collision.scale.y = height_mm
		collision.translation.y = height_mm/2.0

func set_width(value):
	var box1 = get_node_or_null("box_with_cover") as Spatial
	width_mm = value
	if box1:
		box1.scale.z = width_mm/600
	var collision = get_node_or_null("collision") as Spatial
	if collision:
		collision.scale.z = width_mm

func set_depth(value):
	var box2 = get_node_or_null("box_with_cover") as Spatial
	depth_mm = value
	if box2:
		box2.scale.x = depth_mm/430
	var collision = get_node_or_null("collision") as Spatial
	if collision:
		collision.scale.x = depth_mm

func get_cover_joint_1() -> RcsToggleJoint:
	return $box_with_cover/cover_top/cover_joint_1 as RcsToggleJoint
	
func get_cover_joint_2() -> RcsToggleJoint:
	return $box_with_cover/cover_top/cover_joint_2 as RcsToggleJoint
	
func get_cover_joint_3() -> RcsToggleJoint:
	return $box_with_cover/cover_top/cover_joint_3 as RcsToggleJoint
	
func get_cover_joint_4() -> RcsToggleJoint:
	return $box_with_cover/cover_top/cover_joint_4 as RcsToggleJoint
	
	
func get_cover_joint_5() -> RcsToggleJoint:
	return $box_with_cover/cover_bottom/cover_joint_5 as RcsToggleJoint
	
func get_cover_joint_6() -> RcsToggleJoint:
	return $box_with_cover/cover_bottom/cover_joint_6 as RcsToggleJoint
	
func get_cover_joint_7() -> RcsToggleJoint:
	return $box_with_cover/cover_bottom/cover_joint_7 as RcsToggleJoint
	
func get_cover_joint_8() -> RcsToggleJoint:
	return $box_with_cover/cover_bottom/cover_joint_8 as RcsToggleJoint
	
	
	
func set_opened_top(value):
	get_cover_joint_1().TogglePositive = value
	get_cover_joint_2().TogglePositive = value
	get_cover_joint_3().TogglePositive = value
	get_cover_joint_4().TogglePositive = value
	opened_top =  value
	
	if get_cover_joint_1().TogglePositive == false and  get_cover_joint_2().TogglePositive == false:
		get_cover_joint_3().Throttle = 14
		get_cover_joint_4().Throttle = 14
		get_cover_joint_1().Throttle = 7
		get_cover_joint_2().Throttle = 7
	else:
		get_cover_joint_3().Throttle = 7
		get_cover_joint_4().Throttle = 7
		get_cover_joint_1().Throttle = 14
		get_cover_joint_2().Throttle = 14
		
func get_opened_top():
	opened_top = get_cover_joint_1().TogglePositive
	opened_top = get_cover_joint_2().TogglePositive
	opened_top = get_cover_joint_3().TogglePositive
	opened_top = get_cover_joint_4().TogglePositive
	return opened_top



func set_opened_bottom(value):
	get_cover_joint_5().TogglePositive = value
	get_cover_joint_6().TogglePositive = value
	get_cover_joint_7().TogglePositive = value
	get_cover_joint_8().TogglePositive = value
	opened_bottom =  value
	
	if get_cover_joint_5().TogglePositive == false and  get_cover_joint_6().TogglePositive == false:
		get_cover_joint_7().Throttle = 14
		get_cover_joint_8().Throttle = 14
		get_cover_joint_5().Throttle = 7
		get_cover_joint_6().Throttle = 7
	else:
		get_cover_joint_7().Throttle = 7
		get_cover_joint_8().Throttle = 7
		get_cover_joint_5().Throttle = 14
		get_cover_joint_6().Throttle = 14
		
func get_opened_bottom():
	opened_bottom = get_cover_joint_5().TogglePositive
	opened_bottom = get_cover_joint_6().TogglePositive
	opened_bottom = get_cover_joint_7().TogglePositive
	opened_bottom = get_cover_joint_8().TogglePositive
	return opened_bottom
