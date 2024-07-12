tool
extends RcsSignalsHolder


# Declare member variables here. Examples:
# var a = 2
export var part_sensor : NodePath
export var part_sensor2 : NodePath


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var sensor = get_node_or_null(part_sensor) as Area
	var sensor2 = get_node_or_null(part_sensor2) as Area
	if sensor != null:
		set_di(3, not sensor.get_overlapping_bodies().empty())
	if sensor2 != null:
		set_di(2, not sensor2.get_overlapping_bodies().empty())
	#$conveyor/RcsConveyor.DriveRunning = false
