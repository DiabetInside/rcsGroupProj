tool
extends Spatial

export(float, 100, 2000) var height = 350  setget set_height
export(float, 100, 2000) var center_size = 300  setget set_center_size
export(float, 100, 2000) var platform_size = 500  setget set_platform_size
export(String, "Rounded", "Squared") var platform_shape = "Squared"  setget set_platform_shape

func _init():
	height = 350
	center_size = 300
	platform_size = 500
	platform_shape = "Squared"

func _ready():
	var Base_1 = get_node("Base_1")
	var Base_2 = get_node("Base_2")
	Base_1.scale = Vector3(1, 1, 1)
	Base_2.scale = Vector3(1, 1, 1)
	Base_1.rotation_degrees = Vector3(0, 45, 0)
	Base_2.rotation_degrees = Vector3(0, 45, 0)
	
func set_height(value):
	height = value
	var Cube = get_node_or_null("Cube") as MeshInstance
	if Cube:
		Cube.scale.y = height
		Cube.translation.y = height / 2.0
	var Base_2 = get_node_or_null("Base_2") as MeshInstance
	var Base_1 = get_node_or_null("Base_1") as MeshInstance
	if Base_2:
		Base_2.translation.y = height + 2


func set_center_size(value):
	var Cube = get_node_or_null("Cube") as MeshInstance
	center_size = value
	if Cube:
		Cube.scale.z = (center_size * 2 /420)
		Cube.scale.x = (center_size * 2 /420)
		if value >= platform_size - 150:
			set_platform_size(value + 151)
			_editor_changed()



func set_platform_size(value):
	platform_size = value
	var Base_1 = get_node_or_null("Base_1") as MeshInstance
	var Base_2 = get_node_or_null("Base_2") as MeshInstance
	if Base_1 && Base_2:
		Base_1.scale.x = platform_size / 450
		Base_1.scale.z = platform_size / 450
		Base_2.scale.x = platform_size / 450
		Base_2.scale.z = platform_size / 450
		if center_size >= platform_size - 160:
			set_center_size(platform_size - 160)
			_editor_changed()

func set_platform_shape(value):
	platform_shape = value
	var Base_1 = get_node_or_null("Base_1") as MeshInstance
	var Base_2 = get_node_or_null("Base_2") as MeshInstance
	var Cube = get_node_or_null("Cube") as MeshInstance
	if Base_1:
		match platform_shape:
			"Squared":
				Base_1.mesh.set_radial_segments(4)
				Base_2.mesh.set_radial_segments(4)
				Cube.mesh.set_radial_segments(4)
			"Rounded":
				Base_1.mesh.set_radial_segments(32)
				Base_2.mesh.set_radial_segments(32)
				Cube.mesh.set_radial_segments(32)
			
	
func _editor_changed():
	var _run = true
	yield(get_tree().create_timer(0.5), "timeout")
	if _run == true:
		property_list_changed_notify()
		_run = false
