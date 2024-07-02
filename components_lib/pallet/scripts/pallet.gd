tool 
extends Spatial
export(float, 100, 500, 0.1) var high_of_pallet_mm = 250 setget set_high_of_pallet
export(float, 500, 2400, 0.1) var width_of_pallet_mm = 1200 setget set_width_of_pallet
export(float, 500, 2000, 0.1) var depth_of_pallet_mm = 1000 setget set_depth_of_pallet



func set_high_of_pallet(value):
	high_of_pallet_mm = value
	var high = get_node_or_null("cubes") as Spatial
	if high:
		high.scale.y = high_of_pallet_mm /250
	var high_board = get_node_or_null("board2") as Spatial
	if high_board:
		high_board.translation.y = high_of_pallet_mm  -100
	var high_boards = get_node_or_null("boards") as Spatial
	if high_boards:
		high_boards.translation.y = high_of_pallet_mm
		

func set_width_of_pallet(value):
	width_of_pallet_mm = value
	var width = get_node_or_null("board_down") as Spatial
	if width:
		width.scale.z = width_of_pallet_mm  /1200
	var width_board = get_node_or_null("boards") as Spatial
	if width_board:
		width_board.scale.z = width_of_pallet_mm  /1200
	var width_cube_1_2 = get_node_or_null("cubes/Cube_1_2") as Spatial
	if width_cube_1_2:
		width_cube_1_2.translation.z = width_of_pallet_mm /2
	var width_cube_2_2 = get_node_or_null("cubes/Cube_2_2") as Spatial
	if width_cube_2_2:
		width_cube_2_2.translation.z = width_of_pallet_mm /2
	var width_cube_3_2 = get_node_or_null("cubes/Cube_3_2") as Spatial
	if width_cube_3_2:
		width_cube_3_2.translation.z = width_of_pallet_mm /2
	var width_board7 = get_node_or_null("board2/board7") as Spatial
	if width_board7:
		width_board7.translation.z = width_of_pallet_mm /2
	var width_cube_1_3 = get_node_or_null("cubes/Cube_1_3") as Spatial
	if width_cube_1_3:
		width_cube_1_3.translation.z = width_of_pallet_mm  -72.5
	var width_cube_2_3 = get_node_or_null("cubes/Cube_2_3") as Spatial
	if width_cube_2_3:
		width_cube_2_3.translation.z = width_of_pallet_mm  -72.5
	var width_cube_3_3 = get_node_or_null("cubes/Cube_3_3") as Spatial
	if width_cube_3_3:
		width_cube_3_3.translation.z = width_of_pallet_mm -72.5
	var width_board8 = get_node_or_null("board2/board8") as Spatial
	if width_board8:
		width_board8.translation.z = width_of_pallet_mm  -72.5



func set_depth_of_pallet(value):
	depth_of_pallet_mm = value
	var depth_board2= get_node_or_null("board2") as Spatial
	if depth_board2:
		depth_board2.scale.x = depth_of_pallet_mm / 1200
	var depth_board_2 = get_node_or_null("board_down/board_2") as Spatial
	if depth_board_2:
		depth_board_2.translation.x = depth_of_pallet_mm /2
	var depth_board_3 = get_node_or_null("board_down/board_3") as Spatial
	if depth_board_3:
		depth_board_3.translation.x = depth_of_pallet_mm -50
	var depth_boards_1_1 = get_node_or_null("boards/board_1_1") as Spatial
	if depth_boards_1_1:
		depth_boards_1_1.translation.x = depth_of_pallet_mm* 0.2901356
	var depth_boards_2 = get_node_or_null("boards/board_2") as Spatial
	if depth_boards_2:
		depth_boards_2.translation.x = depth_of_pallet_mm/2
	var depth_boards_2_2 = get_node_or_null("boards/board_2_2") as Spatial
	if depth_boards_2_2:
		depth_boards_2_2.translation.x = depth_of_pallet_mm *0.711111
	var depth_boards_3 = get_node_or_null("boards/board_3") as Spatial
	if depth_boards_3:
		depth_boards_3.translation.x = depth_of_pallet_mm -72.5
	var depth_cube_2_1 = get_node_or_null("cubes/Cube_2_1") as Spatial
	if depth_cube_2_1:
		depth_cube_2_1.translation.x = depth_of_pallet_mm/2
	var depth_cube_2_2 = get_node_or_null("cubes/Cube_2_2") as Spatial
	if depth_cube_2_2:
		depth_cube_2_2.translation.x = depth_of_pallet_mm /2
	var depth_cube_2_3 = get_node_or_null("cubes/Cube_2_3") as Spatial
	if depth_cube_2_3:
		depth_cube_2_3.translation.x = depth_of_pallet_mm/2
	var depth_cube_3_1 = get_node_or_null("cubes/Cube_3_1") as Spatial
	if depth_cube_3_1:
		depth_cube_3_1.translation.x = depth_of_pallet_mm-50
	var depth_cube_3_2 = get_node_or_null("cubes/Cube_3_2") as Spatial
	if depth_cube_3_2:
		depth_cube_3_2.translation.x = depth_of_pallet_mm -50
	var depth_cube_1_3 = get_node_or_null("cubes/Cube_1_3") as Spatial
	if depth_cube_1_3:
		depth_cube_1_3.translation.x = depth_of_pallet_mm-50

