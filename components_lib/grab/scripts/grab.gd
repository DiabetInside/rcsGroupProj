
tool
extends Node

export(float) var lifted_of_arms_mm = 100 setget set_lifted
export(float) var width_tip_of_arms_mm = 10  setget set_width_of_tip
export(float) var width_of_arms_mm = 54  setget set_width
export(float) var lenght_of_arms_mm = 64  setget set_lenght
export(float) var radius_of_flange_mm = 42  setget set_radius
export(float) var hight_of_flange_mm = 23  setget set_hight
export(bool) var do_grab = false

func set_radius(value):
	radius_of_flange_mm = value
	var flange = get_node_or_null("grab/flange1") as MeshInstance
	if flange:
		flange.scale.z = radius_of_flange_mm/42
		flange.scale.y = radius_of_flange_mm/42

func set_hight(value):
	hight_of_flange_mm = value
	var flange = get_node_or_null("grab/flange1") as MeshInstance
	if flange:
		flange.scale.x = hight_of_flange_mm/23

func set_lifted(value):
	lifted_of_arms_mm = value
	var arm_1 = get_node_or_null("grab/RcsToggleJoint/fingers1") as MeshInstance
	if arm_1:
		arm_1.translation.x = lifted_of_arms_mm/2+65.5015;
	var arm_2 = get_node_or_null("grab/RcsToggleJoint2/fingers2") as MeshInstance
	if arm_2:
		arm_2.translation.x = -lifted_of_arms_mm/2-65.485;
	var col_lifted = get_node_or_null("RcsGrabber/CollisionShape") as CollisionShape
	if col_lifted:
		col_lifted.scale.x = (arm_1.translation.x - 62*2 - arm_2.translation.x)/(2)

func set_width_of_tip(value):
	width_tip_of_arms_mm = value
	var width_grid1 = get_node_or_null("grab/RcsToggleJoint/fingers1/grip13") as MeshInstance
	if width_grid1:
		width_grid1.scale.z = width_tip_of_arms_mm/10
	var width_grid2 = get_node_or_null("grab/RcsToggleJoint2/fingers2/grip23") as MeshInstance
	if width_grid2:
		width_grid2.scale.z = width_tip_of_arms_mm/10
	var arm_1_width = get_node_or_null("grab/RcsToggleJoint/fingers1") as MeshInstance
	var arm_2_width = get_node_or_null("grab/RcsToggleJoint2/fingers2") as MeshInstance
	var col_width = get_node_or_null("RcsGrabber/CollisionShape") as CollisionShape
	if col_width:
		col_width.scale.x = (arm_1_width.translation.x - 39*2 - arm_2_width.translation.x-2*10*width_grid1.scale.z-2*3*width_grid1.scale.z-20)/2

func set_width(value):
	width_of_arms_mm = value
	var width_grid13 = get_node_or_null("grab/RcsToggleJoint/fingers1/grip13") as MeshInstance
	if width_grid13:
		width_grid13.scale.x = width_of_arms_mm/54
		width_grid13.translation.x = -width_of_arms_mm/2+27
	var width_grid23 = get_node_or_null("grab/RcsToggleJoint2/fingers2/grip23") as MeshInstance
	if width_grid23:
		width_grid23.scale.x = width_of_arms_mm/54
		width_grid23.translation.x = -width_of_arms_mm/2+27
	var width_grid12 = get_node_or_null("grab/RcsToggleJoint/fingers1/grip12") as MeshInstance
	if width_grid12:
		width_grid12.scale.z = width_of_arms_mm/54
		width_grid12.translation.x = width_of_arms_mm/2+27
	var width_grip22 = get_node_or_null("grab/RcsToggleJoint2/fingers2/grip22") as MeshInstance
	if width_grip22:
		width_grip22.scale.z = width_of_arms_mm/54
		width_grip22.translation.x = width_of_arms_mm/2+27
	var col_width = get_node_or_null("RcsGrabber/CollisionShape") as CollisionShape
	if col_width:
		col_width.scale.y = width_of_arms_mm/54

func set_lenght(value):
	lenght_of_arms_mm = value
	var lenght_grid13 = get_node_or_null("grab/RcsToggleJoint/fingers1/grip13") as MeshInstance
	if lenght_grid13:
		lenght_grid13.scale.y = lenght_of_arms_mm/64
	var lenght_grid23 = get_node_or_null("grab/RcsToggleJoint2/fingers2/grip23") as MeshInstance
	if lenght_grid23:
		lenght_grid23.scale.y = lenght_of_arms_mm/64
	var col_shape = get_node_or_null("RcsGrabber/CollisionShape") as CollisionShape
	if col_shape:
		col_shape.scale.z = lenght_of_arms_mm/64
		col_shape.translation.z = lenght_of_arms_mm/2-32
	

class_name gripper_library

var _grab_state = true
export (bool) var grab_state setget set_grab_state, get_grab_state


const GRIPPER_1_CLOSED = 1
const GRIPPER_1_RELEASED = 2
const GRIPPER_2_CLOSED = 3
const GRIPPER_2_RELEASED = 4

func _ready():
	set_grab_state(false)


func set_grab_state(value:bool):
	_grab_state = value
	var grabber = get_node_or_null("RcsGrabber") as RcsGrabber
	var joint_1 = get_node_or_null("grab/RcsToggleJoint") as RcsToggleJoint
	var joint_2 = get_node_or_null("grab/RcsToggleJoint2") as RcsToggleJoint
	if(grabber != null):
		if(value == true):
			grabber.grab()				
		else:
			grabber.drop()
	if (joint_1 != null):
		joint_1.set_toggle_dir(value)
	if (joint_2 != null):
		joint_2.set_toggle_dir(value)
		
func get_grab_state():
	return _grab_state


#TODO make sensor_nr enum-like
func get_rcs_sensor_state(sensor_nr:int): 
	var joint_1 = get_node_or_null("grab/RcsToggleJoint") as RcsToggleJoint
	var joint_2 = get_node_or_null("grab/RcsToggleJoint2") as RcsToggleJoint
	if (joint_1 != null):
		if (sensor_nr == GRIPPER_1_CLOSED):
			return joint_1.is_right_limit()
		if (sensor_nr == GRIPPER_1_RELEASED):
			return joint_1.is_left_limit()
	if (joint_2 != null):
		if (sensor_nr == GRIPPER_2_CLOSED):
			return joint_2.is_right_limit()
		if (sensor_nr == GRIPPER_2_RELEASED):
			return joint_2.is_left_limit()
			
func _process(delta):
	if do_grab:
		self.set_grab_state(true)
	else:
		self.set_grab_state(false)
		
func set_rcs_control_signal(value):
	print("RcsGrabber::set_rcs_conrtol_signal(value), value = ", value)
	self.do_grab = value
	print("New value of do_grab = ", self.do_grab)
