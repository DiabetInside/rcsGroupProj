tool
extends RcsPathConveyor

#общие параметры
export(float, 500.0, 2500.0, 0.1) var width_conveyor_MM = 500.0 setget set_width_conveyor
export(float, 250.0, 5000.0, 0.1) var height_conveyor_MM = 615.9 setget set_lower_height_conveyor
#ножки (количество)
export(int, 4, 30, 2) var number_of_leg = 8 setget set_legs_count
export(String, "On the left and right", "On the left", "On the right", "None") var engine = "On the left and right" setget set_engine_visible
export(String, "On the left and right", "On the left", "On the right", "None") var board = "On the left and right" setget set_board_visible#, get_board_right_false, get_board_left_false
export(float, 50.0, 1000.0, 0.1) var height_board_MM = 100.0 setget set_height_board
#ступени (наличие, количество, высота)

#верхний участок 
export(float, 500.0, 6000.0, 0.1) var length_top_conveyor_MM = 1500.0 setget set_length_conveyor_higher
export(String, "At the beginning and end of the conveyor", "At the beginning of the conveyor belt", "At the end of the conveyor", "None") var Top_availability_of_the_knife = "At the beginning of the conveyor belt" setget set_knife_visible_higher

#средний участок
export(float, 0.0, 90.0) var tilt_angle = 45.0 setget tilt_setter
export(float, 500.0, 4500.0, 0.1) var length_middle_conveyor_MM = 1370.1 setget set_length_conveyor_sloping
export(String, "At the beginning and end of the conveyor", "At the beginning of the conveyor belt", "At the end of the conveyor", "None") var Middle_availability_of_the_knife = "At the beginning and end of the conveyor" setget set_knife_visible_sloping

#нижний участок 
export(float, 500.0, 6000.0, 0.1) var length_lower_conveyor_MM = 500.0 setget set_length_conveyor_lower
export(String, "At the beginning and end of the conveyor", "At the beginning of the conveyor belt", "At the end of the conveyor", "None") var Lower_availability_of_the_knife = "At the end of the conveyor" setget set_knife_visible

var row_step_legs = 526.5 setget set_legs_row
var last_toggle: bool
var changed: bool
var last_change_timestamp: int
var loaded = false
var time_passed = 0

func all_func():
# нижний уровень
	var height_board_lo = get_node_or_null("./Lower/Board") as Spatial
	var Lower_board_r = get_node_or_null("./Lower/Board/Board_right") as MeshInstance
	var Lower_board_l = get_node_or_null("./Lower/Board/Board_left") as MeshInstance
	var length_conveyor_l = get_node_or_null("./Lower/conveyor") as MeshInstance
	var hieght_conveyor_l = get_node_or_null("./Lower") as Spatial
	var areaMonitor = get_node_or_null("./RcsAreaMonitor") as RcsAreaMonitor

# средний уровень
	var length_conveyor_s = get_node_or_null("./Middle/conveyor_s/title/conv/conveyor") as MeshInstance
	var length_board_right_s = get_node_or_null ("./Middle/conveyor_s/title/Board/Board_right") as MeshInstance
	var length_board_left_s = get_node_or_null ("./Middle/conveyor_s/title/Board/Board_left") as MeshInstance
	var length_engine_s = get_node_or_null ("./Middle/conveyor_s/title/Engine") as Spatial
	var length_higher_s = get_node_or_null("./Middle/conveyor_s") as Spatial
	var height_engine_s_r = get_node_or_null("./Middle/conveyor_s/title/Engine/engine_right") as MeshInstance
	var height_engine_s_l = get_node_or_null("./Middle/conveyor_s/title/Engine/engine_left") as MeshInstance

#высокий уровень
	var length_conveyor_h = get_node_or_null("./Top/conveyor") as MeshInstance
	var length_higher = get_node_or_null("./Top") as Spatial
	var length_board_right_h = get_node_or_null ("./Top/Board/Board_right") as MeshInstance
	var length_board_left_h = get_node_or_null ("./Top/Board/Board_left") as MeshInstance
	var length_engine_h = get_node_or_null ("./Top/Engine") as Spatial
	var higher_board_r = get_node_or_null("./Top/Board/Board_right") as MeshInstance
	var higher_board_l = get_node_or_null("./Top/Board/Board_left") as MeshInstance

	var title = get_node_or_null("./Middle/conveyor_s/title") as RcsJoint
	var angle: float = tilt_angle * PI / 180.0

	if title :
		title.JointValue = 0
		title.base_translation.z = length_lower_conveyor_MM * 0.5
		title.base_translation.z = 0
		title.translation.z = length_lower_conveyor_MM * 0.5
		title.base_translation.y = height_conveyor_MM
		title.translation.y = height_conveyor_MM
		title.JointValue = angle

#смещение бортов
	if higher_board_r and higher_board_l and Lower_board_r and Lower_board_l \
	and length_board_right_s and length_board_left_s:
		higher_board_r.translation.y = height_board_MM * 0.5
		higher_board_l.translation.y = height_board_MM * 0.5
		Lower_board_r.translation.y = height_board_MM * 0.5
		Lower_board_l.translation.y = height_board_MM * 0.5
		length_board_right_s.translation.y = height_board_MM * 0.5
		length_board_left_s.translation.y = height_board_MM * 0.5

#длина нижнего уровень конвейера
	if length_conveyor_l and Lower_board_r and Lower_board_l and height_board_lo and areaMonitor:
		length_conveyor_l.scale.x = length_lower_conveyor_MM / 1053.0
		length_conveyor_l.translation.x = length_lower_conveyor_MM / 2.15
		areaMonitor.translation.x = length_lower_conveyor_MM - 70
		Lower_board_r.scale.x = length_lower_conveyor_MM / 1053.0
		Lower_board_r.translation.x = length_lower_conveyor_MM / 1053.0 * 0.01
		Lower_board_l.scale.x = length_lower_conveyor_MM / 1053.0
		length_conveyor_l.translation.y = height_conveyor_MM
		height_board_lo.translation.y = height_conveyor_MM
		areaMonitor.translation.y = height_conveyor_MM + 68

#средний уровень конвейера
	if length_conveyor_s and length_board_right_s and length_board_left_s and \
	length_engine_s and length_higher and length_higher_s:
		length_conveyor_s.scale.x = -length_middle_conveyor_MM / 1053.0
		length_conveyor_s.translation.x = -length_middle_conveyor_MM * 0.5
		length_board_right_s.scale.x = -length_middle_conveyor_MM / 1053.0
		length_board_right_s.translation.x = -length_middle_conveyor_MM / 1053.0 * 0.01
		length_board_left_s.scale.x = -length_middle_conveyor_MM / 1053.0
		length_engine_s.translation.x = -length_middle_conveyor_MM + 50

#верхний уровень конвейера
	if length_conveyor_h and length_higher and length_board_right_h and length_board_left_h and length_engine_h:
		length_conveyor_h.scale.x = -length_top_conveyor_MM / 1053.0
		length_conveyor_h.translation.x = -length_top_conveyor_MM * 0.5
		length_board_right_h.scale.x = -length_top_conveyor_MM / 1053.0
		length_board_right_h.translation.x = length_top_conveyor_MM / 1053.0 * 0.01
		length_board_left_h.scale.x = -length_top_conveyor_MM / 1053.0
		length_engine_h.translation.x = -length_top_conveyor_MM + 50
		
		if length_middle_conveyor_MM > 3000.0 and angle < 15.0:
			length_higher.translation.y = height_conveyor_MM + length_middle_conveyor_MM * sin(angle) - 50
			length_higher.translation.x =  -length_middle_conveyor_MM * cos(angle) + 150

		if length_middle_conveyor_MM < 3000.0 and angle >= 0.0 :
			length_higher.translation.y = height_conveyor_MM + length_middle_conveyor_MM * sin(angle)
			length_higher.translation.x = -length_middle_conveyor_MM * cos(angle) + 150

	set_legs_count(number_of_leg)
	
#height_conveyor нижнего участка
func set_lower_height_conveyor (height):
	height_conveyor_MM = height
	if (!loaded): return
	all_func()
	set_legs_count(number_of_leg)
	update_legs_length()

#длина среднего участка 
func set_length_conveyor_sloping (length):
	length_middle_conveyor_MM = length
	if (!loaded): return
	all_func()

#width_conveyor 
func set_width_conveyor (width):
	width_conveyor_MM = width
	if (!loaded): return
	var width_right_engine = get_node_or_null("./Top/Engine/engine_right") as MeshInstance
	var width_left_engine = get_node_or_null("./Top/Engine/engine_left") as MeshInstance
	var width_conveyor_s = get_node_or_null("./Middle/conveyor_s/title/conv/conveyor") as MeshInstance
	var width_conveyor_h = get_node_or_null("./Top/conveyor") as MeshInstance
	var width_conveyor_l = get_node_or_null("./Lower/conveyor") as MeshInstance
	var width_board_right_l = get_node_or_null ("./Lower/Board/Board_right") as MeshInstance
	var width_board_left_l = get_node_or_null ("./Lower/Board/Board_left") as MeshInstance
	var width_board_right_s = get_node_or_null ("./Middle/conveyor_s/title/Board/Board_right") as MeshInstance
	var width_board_left_s = get_node_or_null ("./Middle/conveyor_s/title/Board/Board_left") as MeshInstance
	var width_board_right_h = get_node_or_null ("./Top/Board/Board_right") as MeshInstance
	var width_board_left_h = get_node_or_null ("./Top/Board/Board_left") as MeshInstance
	var areaMonitor = get_node_or_null("./RcsAreaMonitor") as RcsAreaMonitor

	width_conveyor_s.scale.z = width * 0.0025
	areaMonitor.scale.z = width * 0.0025
	width_conveyor_h.scale.z = width * 0.0025
	width_conveyor_l.scale.z = width * 0.0025
	width_right_engine.translation.z = -width / 1.9 - 8
	width_left_engine.translation.z = width / 1.9 + 28
	width_board_right_l.translation.z = -width / 2.1
	width_board_left_l.translation.z = width * 0.5
	width_board_right_s.translation.z = -width / 2.1
	width_board_left_s.translation.z = width * 0.5
	width_board_right_h.translation.z = -width / 2.1
	width_board_left_h.translation.z = width * 0.5
	set_legs_count(number_of_leg)
	all_func()

#length_conveyor_higher 
func set_length_conveyor_higher (length):
	length_top_conveyor_MM =length
	if (!loaded): return
	set_legs_count(number_of_leg)
	all_func()
	update_legs_length()

#length_conveyor_lower
func set_length_conveyor_lower (length):
	length_lower_conveyor_MM =length
	if (!loaded): return
	set_legs_count(number_of_leg)
	all_func()
	update_legs_length()

#смещение и высота бортиков
func set_height_board (value):
	height_board_MM = value
	if (!loaded): return
	$Lower/Board/Board_left/board_left.scale.y = height_board_MM * 0.01
	$Lower/Board/Board_right/board_right.scale.y = height_board_MM * 0.01
	$Top/Board/Board_left/board_left.scale.y = height_board_MM * 0.01
	$Top/Board/Board_right/board_right.scale.y = -height_board_MM * 0.01
	$Middle/conveyor_s/title/Board/Board_left/board_left.scale.y = height_board_MM * 0.01
	$Middle/conveyor_s/title/Board/Board_right/board_right.scale.y = height_board_MM * 0.01
	all_func()

#видимость приводов
func set_engine_visible(value):
	engine = value
	var engine_right = get_node_or_null("./Top/Engine/engine_right") as MeshInstance
	var engine_left = get_node_or_null("./Top/Engine/engine_left") as MeshInstance
	var engine_right_s = get_node_or_null("./Middle/conveyor_s/title/Engine/engine_right") as MeshInstance
	var engine_left_s = get_node_or_null("./Middle/conveyor_s/title/Engine/engine_left") as MeshInstance

	if engine_right and engine_left and engine_right_s and engine_left_s:
		if engine == "On the left and right":
			engine_left.visible = true
			engine_right.visible = true
			engine_right_s.visible = false
			engine_left_s.visible = false
		if engine == "On the left":
			engine_left.visible = true
			engine_right.visible = false
			engine_right_s.visible = false
			engine_left_s.visible = false
		if engine == "On the right":
			engine_left.visible = false
			engine_right.visible = true
			engine_right_s.visible = false
			engine_left_s.visible = false
		if engine == "None":
			engine_left.visible = false
			engine_right.visible = false
			engine_right_s.visible = false
			engine_left_s.visible = false
	update_legs_length()

#видимость бортиков
func set_board_visible(value):
	board = value
	var board_right = get_node_or_null("./Lower/Board/Board_right") as MeshInstance
	var board_left = get_node_or_null("./Lower/Board/Board_left") as MeshInstance
	var board_right_h = get_node_or_null("./Top/Board/Board_right") as MeshInstance
	var board_left_h = get_node_or_null("./Top/Board/Board_left") as MeshInstance
	var board_right_s = get_node_or_null("./Middle/conveyor_s/title/Board/Board_right") as MeshInstance
	var board_left_s = get_node_or_null("./Middle/conveyor_s/title/Board/Board_left") as MeshInstance
	
	if board_right and board_left and board_right_h and board_left_h and board_right_s and board_left_s:
		if board == "On the left and right":
			board_left.visible = true
			board_right_h.visible = true
			board_left_h.visible = true
			board_right.visible = true
			board_left_s.visible = true
			board_right_s.visible = true
		if board == "On the left":
			board_left.visible = true
			board_right_h.visible = false
			board_left_h.visible = true
			board_right.visible = false
			board_left_s.visible = true
			board_right_s.visible = false
		if board == "On the right":
			board_left.visible = false
			board_right_h.visible = true
			board_left_h.visible = false
			board_right.visible = true
			board_left_s.visible = false
			board_right_s.visible = true
		if board == "None":
			board_left.visible = false
			board_right_h.visible = false
			board_left_h.visible = false
			board_right.visible = false
			board_left_s.visible = false
			board_right_s.visible = false
	update_legs_length()
	
#Видимость ножа нижнего конвейера
func set_knife_visible(value):
	Lower_availability_of_the_knife = value
	var knife_transition_1 = get_node_or_null("./Lower/conveyor/knife_transition_1") as MeshInstance
	var knife_transition_2 = get_node_or_null("./Lower/conveyor/knife_transition_2") as MeshInstance
	
	if knife_transition_2 and knife_transition_1:
		if Lower_availability_of_the_knife == "At the beginning and end of the conveyor":
			knife_transition_1.visible = true
			knife_transition_2.visible = true
		if Lower_availability_of_the_knife == "At the beginning of the conveyor belt":
			knife_transition_1.visible = true
			knife_transition_2.visible = false
		if Lower_availability_of_the_knife == "At the end of the conveyor":
			knife_transition_1.visible = false
			knife_transition_2.visible = true
		if Lower_availability_of_the_knife == "None":
			knife_transition_1.visible = false
			knife_transition_2.visible = false

#Видимость ножа верхнего конвейера
func set_knife_visible_higher(value):
	Top_availability_of_the_knife = value
	var knife_transition_h = get_node_or_null("./Top/conveyor/knife_transition_1") as MeshInstance
	var knife_transition_h2 = get_node_or_null("./Top/conveyor/knife_transition_2") as MeshInstance
	
	if knife_transition_h and knife_transition_h2:
		if Top_availability_of_the_knife == "At the beginning and end of the conveyor":
			knife_transition_h.visible = true
			knife_transition_h2.visible = true
		if Top_availability_of_the_knife == "At the beginning of the conveyor belt":
			knife_transition_h.visible = true
			knife_transition_h2.visible = false
		if Top_availability_of_the_knife == "At the end of the conveyor":
			knife_transition_h.visible = false
			knife_transition_h2.visible = true
		if Top_availability_of_the_knife == "None":
			knife_transition_h.visible = false
			knife_transition_h2.visible = false

#Видимость ножа среднего конвейера
func set_knife_visible_sloping(value):
	Middle_availability_of_the_knife = value
	var knife_transition_s = get_node_or_null("./Middle/conveyor_s/title/conv/conveyor/knife_transition_1") as MeshInstance
	var knife_transition_s2 = get_node_or_null("./Middle/conveyor_s/title/conv/conveyor/knife_transition_2") as MeshInstance
	
	if knife_transition_s and knife_transition_s2:
		if Middle_availability_of_the_knife == "At the beginning and end of the conveyor":
			knife_transition_s.visible = true
			knife_transition_s2.visible = true
		if Middle_availability_of_the_knife == "At the beginning of the conveyor belt":
			knife_transition_s.visible = true
			knife_transition_s2.visible = false
		if Middle_availability_of_the_knife == "At the end of the conveyor":
			knife_transition_s.visible = false
			knife_transition_s2.visible = true
		if Middle_availability_of_the_knife == "None":
			knife_transition_s.visible = false
			knife_transition_s2.visible = false

func tilt_setter(value):
	tilt_angle = value
	all_func()

func conns_scaler(part, part_name):
	if part_name == "leg1":
		if board == "On the left and right":
			part.translation.z = -(100 + width_conveyor_MM * 0.5)
		if board == "On the left":
			part.translation.z = -(100 + width_conveyor_MM * 0.5) + 16.6
		if board == "On the right" :
			part.translation.z = -(100 + width_conveyor_MM * 0.5)
		if board == "None":
			part.translation.z = -(100 + width_conveyor_MM * 0.5) + 16.6

func rebuild_conveyor_size():
	set_width_conveyor(width_conveyor_MM)
	set_lower_height_conveyor(height_conveyor_MM)
	set_height_board (height_board_MM)
	set_length_conveyor_higher(length_top_conveyor_MM )
	set_length_conveyor_sloping(length_middle_conveyor_MM )
	set_length_conveyor_lower (length_lower_conveyor_MM)
	update_legs_length()

func _process(delta):
	if (OS.get_system_time_msecs() - time_passed > 800 and changed):
		property_list_changed_notify()
		changed = false
		time_passed = OS.get_system_time_msecs()

#Генерация ног
func rebuild_legs():
	time_passed = OS.get_system_time_msecs()
	changed = true
	var Legs_Generator_1 = get_node_or_null("Legs_Generator_1") as RcsGridPartGenerator
	var Legs_Generator_2 = get_node_or_null("Legs_Generator_2") as RcsGridPartGenerator
	if Legs_Generator_1:
		Legs_Generator_1.clear_parts()
		Legs_Generator_1.rebuild_parts()
	if Legs_Generator_2:
		Legs_Generator_2.clear_parts()
		Legs_Generator_2.rebuild_parts()
	update_legs_length()

func set_legs_row(value):
	if (row_step_legs == value): return
	row_step_legs = value
	if (!loaded): return
	var Legs_Generator_1 = get_node_or_null("Legs_Generator_1") as RcsGridPartGenerator
	var Legs_Generator_2 = get_node_or_null("Legs_Generator_2") as RcsGridPartGenerator
	var conveyor = get_node_or_null("Conveyor/conveyor") as MeshInstance
	var legs_side = number_of_leg/2

	if conveyor:
		var max_row_step = (length_top_conveyor_MM + length_middle_conveyor_MM 
		+ length_lower_conveyor_MM) / (legs_side)
		if row_step_legs > max_row_step:
			row_step_legs = max_row_step
		var row_step_offset = row_step_legs
		if Legs_Generator_1:
			Legs_Generator_1.row_step = Vector3(row_step_offset, 0, 0)
			Legs_Generator_1.translation.x = (legs_side - 1) * row_step_offset * 0.5
		if Legs_Generator_2:
			Legs_Generator_2.row_step = Vector3(row_step_offset,0, 0)
			Legs_Generator_2.translation.x = (legs_side - 1) * row_step_offset * 0.5
		rebuild_legs()
		update_legs_length()

func get_leg_heght(var pos: float) -> float:
	var default_len = length_lower_conveyor_MM * 0.8
	if abs(pos) <= default_len: 
		return height_conveyor_MM
	elif abs(pos) <= cos(tilt_angle * PI / 180.0) * length_middle_conveyor_MM + default_len:
		return tan(tilt_angle * PI / 180.0) * (abs(pos) - default_len) + height_conveyor_MM
	return height_conveyor_MM + sin(tilt_angle * PI / 180.0) * length_middle_conveyor_MM

func update_legs_length():

	var Legs_Generator_1 = get_node_or_null("Legs_Generator_1") as RcsGridPartGenerator
	var Legs_Generator_2 = get_node_or_null("Legs_Generator_2") as RcsGridPartGenerator

	for leg in Legs_Generator_1.get_children():
		var palka = leg.get_child(0) as Spatial
		var leg_length = get_leg_heght(leg.translation.x)
		palka.scale.y = leg_length - 65 
		palka.translation.y = palka.scale.y * 0.5 + 65
		
	for leg in Legs_Generator_2.get_children():
		var palka = leg.get_child(0) as Spatial
		var leg_length = get_leg_heght(leg.translation.x)
		palka.scale.y = leg_length - 65 
		palka.translation.y = palka.scale.y * 0.5 + 65

func legs():
	var Legs_Generator_1 = get_node_or_null("Legs_Generator_1") as RcsGridPartGenerator
	var Legs_Generator_2 = get_node_or_null("Legs_Generator_2") as RcsGridPartGenerator
	var legs = get_node_or_null("legs") as RcsGridPartGenerator
	if (!loaded): return
	var legs_side = number_of_leg * 0.5
	if Legs_Generator_1:
		var step: float = 0.8 * (length_top_conveyor_MM + (length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)) 
		+ tilt_angle + length_lower_conveyor_MM) / (legs_side - 1)
		Legs_Generator_1.row_step = Vector3(0.8 * (length_top_conveyor_MM + (length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)) 
		+ tilt_angle + length_lower_conveyor_MM) / (legs_side - 1), 0, 0)
		Legs_Generator_1.translation.x = length_lower_conveyor_MM * 0.8
		Legs_Generator_1.translation.z = -width_conveyor_MM / 1.9
		Legs_Generator_1.rows = legs_side
		var prev = len(Legs_Generator_1.get_children()) - legs_side
		var tmp_counter: int = 1
		var length_middle: float = length_middle_conveyor_MM
		var length_lower: float = length_lower_conveyor_MM
		for leg in Legs_Generator_1.get_children():
			var position: float = 50 + (step * (tmp_counter - 1 - prev))
			for part in leg.get_children():
				if tmp_counter > prev:
					if position <= length_lower:
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = height_conveyor_MM * 0.5 - 100
							part.translation.z = -width_conveyor_MM * 0.5
							conns_scaler(part, part_name)
						if part_name == "leg2":
							part.translation.z = -width_conveyor_MM * 0.5
						if part_name == "cylinder_leg1":
							part.translation.z = -width_conveyor_MM * 0.5
					if position > length_lower_conveyor_MM and position < (length_lower_conveyor_MM + (length_middle_conveyor_MM * cos(tilt_angle * PI / 180))):
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = height_conveyor_MM * 0.5 - 100
							part.translation.z = -width_conveyor_MM * 0.5
							conns_scaler(part, part_name)
						if part_name == "leg2":
							part.translation.z = -width_conveyor_MM * 0.5
							part.translation.z = -width_conveyor_MM * 0.5
						if part_name == "cylinder_leg1":
							part.translation.z = -width_conveyor_MM * 0.5
					if position >= (length_lower_conveyor_MM + length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)):
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = (float(height_conveyor_MM))/2- 100
							conns_scaler(part, part_name)
							part.translation.z = -width_conveyor_MM * 0.5
						if part_name == "leg2":
							part.translation.z = -width_conveyor_MM * 0.5
							part.translation.z = -width_conveyor_MM * 0.5
						if part_name == "cylinder_leg1":
							part.translation.z = -width_conveyor_MM * 0.5
			tmp_counter += 1

	rebuild_legs()
#
	if Legs_Generator_2:
		Legs_Generator_2.row_step = Vector3(0.8 * (length_top_conveyor_MM + length_middle_conveyor_MM + 
		tilt_angle + length_lower_conveyor_MM) / (legs_side - 1), 0, 0)
		Legs_Generator_2.translation.x = (length_top_conveyor_MM + length_middle_conveyor_MM) * 0.8
		Legs_Generator_2.translation.z = width_conveyor_MM * 0.5
		Legs_Generator_2.rows = legs_side
		var step: float = 0.8 * (length_top_conveyor_MM + (length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)) 
		+ tilt_angle + length_lower_conveyor_MM) / (legs_side - 1)
		Legs_Generator_2.row_step = -Vector3(0.8 * (length_top_conveyor_MM + 
		(length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)) + tilt_angle + length_lower_conveyor_MM) / (legs_side - 1), 0, 0)
		Legs_Generator_2.translation.x = length_lower_conveyor_MM * 0.8
		Legs_Generator_2.translation.z = width_conveyor_MM / 1.9
		Legs_Generator_2.rows = legs_side
		var prev = len(Legs_Generator_2.get_children()) - legs_side
		var tmp_counter: int = 1
		var length_middle: float = length_middle_conveyor_MM
		var length_lower: float = length_lower_conveyor_MM
		for leg in Legs_Generator_2.get_children():
			var position: float = 50 + (step * (tmp_counter - 1 - prev))
			for part in leg.get_children():
				if tmp_counter > prev:
					if position <= length_lower:
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = -height_conveyor_MM * 0.5 - 100
							part.translation.z = width_conveyor_MM / 1.7
							conns_scaler(part, part_name)
						if part_name == "leg2":
							part.translation.z = width_conveyor_MM / 1.7
						if part_name == "cylinder_leg1":
							part.translation.z = width_conveyor_MM / 1.7
					if position > length_lower_conveyor_MM and position < (length_lower_conveyor_MM 
					+ (length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0))):
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = height_conveyor_MM * 0.5 - 100
							part.translation.z = width_conveyor_MM / 1.7
							conns_scaler(part, part_name)
						if part_name == "leg2":
							part.translation.z = width_conveyor_MM / 1.7
							part.translation.z = width_conveyor_MM / 1.7
						if part_name == "cylinder_leg1":
							part.translation.z = width_conveyor_MM / 1.7
					if position >= (length_lower_conveyor_MM + length_middle_conveyor_MM * cos(tilt_angle * PI / 180.0)):
						var part_name: String = String(part.get_path()).split("/")[-1]
						if part_name == "leg1":
							part.translation.y = height_conveyor_MM * 0.5 - 100
							conns_scaler(part, part_name)
							part.translation.z = width_conveyor_MM / 1.7
						if part_name == "leg2":
							part.translation.z = width_conveyor_MM / 1.7
							part.translation.z = width_conveyor_MM / 1.7
						if part_name == "cylinder_leg1":
							part.translation.z = width_conveyor_MM / 1.7
			tmp_counter += 1

	rebuild_legs()

func set_legs_count(value):
	number_of_leg = value
	legs()

func _ready():
	loaded = true
	rebuild_legs()
	rebuild_conveyor_size()
