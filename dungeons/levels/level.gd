extends Node3D

## The total rooms to generate
@export var room_count: int = 30
## The minimum size of a room
@export var min_room_size: int = 2
## The maximum size of a room
@export var max_room_size: int = 4
## The space around a room to prevent overlapping
@export var margin_of_room: int = 1
## The size of the dungeon's boundary
@export var boundary_size: int = 50

var room_tiles: Array[PackedVector3Array] = []
var room_positions: PackedVector3Array = []

@onready var grid_map: GridMap = %GridMap


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		grid_map.clear()
		generate_dungeon()


## This method generates a dungeon with corridors and doors
func generate_dungeon() -> void:
	room_tiles.clear()
	room_positions.clear()

	for i in room_count:
		create_room()

	var delaunay_graph: AStar2D = _create_delaunay_graph()
	var mst_graph: AStar2D = _create_mst_graph(delaunay_graph)

	var corridor_graph: AStar2D = mst_graph

	for point in delaunay_graph.get_point_ids():
		for connection in delaunay_graph.get_point_connections(point):
			if connection > point:
				corridor_graph.connect_points(point, connection)

	create_corridor(corridor_graph)


## This method creates a room based on the minimun and maximun room size that can be placed in our gridmap.
## It takes the given margin into account, so that rooms don't overlap with one another.
## The param 'depth' indicates the amount of recursion that is happening inside, so that we don't get an infinite recursion happening.
## If a room has a valid position within our gridmap, we then store it inside our positions and tiles, so we display it later.
func create_room(depth: int = 10) -> void:
	if depth <= 0: return

	# Get the width and height of a room
	var width: int = randi_range(min_room_size, max_room_size)
	var height: int = randi_range(min_room_size, max_room_size)

	# Define the starting position of our room within specific (boundary_size) allowed area of placement
	var starting_position: Vector3 = Vector3(
		randi_range(0, boundary_size - width),
		0,
		randi_range(0, boundary_size - height)
	)

	var room: PackedVector3Array = []

	# Loop to check for available positions to place our room
	# Makes sure the specific margins are taken into account while placing a room
	for row in range(-margin_of_room, height + margin_of_room):
		for column in range(-margin_of_room, width + margin_of_room):
			var pos: Vector3 = starting_position + Vector3(column, 0, row)

			# Verify if the position isn't used by a room, if it is, try again
			if grid_map.get_cell_item(pos) == 0:
				create_room(depth - 1)
				return

			# Check if room within the boundary
			if row >= 0 and row < height and column >= 0 and column < width:
				grid_map.set_cell_item(pos, 0) # 0 is the item index of our room inside the GridMap
				room.append(pos)

	room_tiles.append(room)

	var center_position: Vector3 = Vector3(
		starting_position.x + (float(width) / 2.0),
		0,
		starting_position.z + (float(height) / 2.0)
	)

	room_positions.append(center_position)


## This method generates the points for the corridors, which will be marked as 'Doors'.
## It stores the paths of each connected room based on the closest tile between them.
func create_corridor(graph: AStar2D) -> void:
	var corridors: Array[PackedVector3Array] = []

	for point in graph.get_point_ids():
		for connected_point in graph.get_point_connections(point):
			if point < connected_point:
				var start_room: PackedVector3Array = room_tiles[point]
				var end_room: PackedVector3Array = room_tiles[connected_point]

				var start_tile: Vector3 = start_room[0]
				var end_tile: Vector3 = end_room[0]

				for tile in start_room:
					if tile.distance_squared_to(room_positions[connected_point]) <\
						start_tile.distance_squared_to(room_positions[connected_point]):
							start_tile = tile

				for tile in end_room:
					if tile.distance_squared_to(room_positions[point]) <\
						end_tile.distance_squared_to(room_positions[point]):
							end_tile = tile

				var corridor: PackedVector3Array = [start_tile, end_tile]

				corridors.append(corridor)

				# 2 is a the door item in our gridmap, we use it to mark the points where the corridor will start and end
				grid_map.set_cell_item(start_tile, 2)
				grid_map.set_cell_item(end_tile, 2)

	# Pass over our corridors variable, so we can generate the actual corridors with AStarGrid
	_process_corridors(corridors)


## This method generates a delaunay triangulation graph that connects all the room positions.
## The graph is built with AStar2d, since we want to get the shortest path that generates between the rooms.
##
## Source used: https://en.wikipedia.org/wiki/Delaunay_triangulation
func _create_delaunay_graph() -> AStar2D:
	var delaunay_graph: AStar2D = AStar2D.new()

	var flattened_room_positions: PackedVector2Array = []

	for pos in room_positions:
		flattened_room_positions.append(Vector2(pos.x, pos.z))
		delaunay_graph.add_point(delaunay_graph.get_available_point_id(), Vector2(pos.x, pos.z))

	var delaunay_edges: Array = Array(Geometry2D.triangulate_delaunay(flattened_room_positions))

	while delaunay_edges.size() >= 3:
		var point_1: int = delaunay_edges.pop_front()
		var point_2: int = delaunay_edges.pop_front()
		var point_3: int = delaunay_edges.pop_front()

		delaunay_graph.connect_points(point_1, point_2)
		delaunay_graph.connect_points(point_1, point_3)
		delaunay_graph.connect_points(point_2, point_3)

	return delaunay_graph


## This method generates a minimum spanning tree from the delaunay graph that is provided.
## We do this, so we can connect all the possible rooms inside our dungeon that is generated based on the shortest distance.
## This also helps in making sure there is only one path between the two rooms we try to connect and not more.
##
## Source used: https://en.wikipedia.org/wiki/Minimum_spanning_tree
func _create_mst_graph(delaunay_graph: AStar2D) -> AStar2D:
	var mst_graph: AStar2D = AStar2D.new()

	var flattened_room_positions: PackedVector2Array = []

	for pos in room_positions:
		flattened_room_positions.append(Vector2(pos.x, pos.z))
		mst_graph.add_point(mst_graph.get_available_point_id(), Vector2(pos.x, pos.z))

	var connected_rooms: PackedInt32Array = []

	# Append a random visited point as the starting position for our algorithmn
	connected_rooms.append(randi_range(0, room_positions.size() - 1))

	while connected_rooms.size() != mst_graph.get_point_count():
		var connections: Array[PackedInt32Array] = []

		# We want to start with looping through all the rooms that are currently connected inside the delaunay graph
		# Afterwards, we check if they are added to our 'connected_rooms' variable, if not, we add it
		for connected_room in connected_rooms:
			for connection in delaunay_graph.get_point_connections(connected_room):
				if not connected_rooms.has(connection):
					var room_connection: PackedInt32Array = [connected_room, connection]
					connections.append(room_connection)

		var preferred_connection: PackedInt32Array = connections.pick_random()

		# Now we want to try to find the shortest connection between the rooms
		# We compare the two rooms, and if we current one has a smaller distance, we set it as our new connection
		for connection in connections:
			if flattened_room_positions[connection[0]].distance_squared_to(flattened_room_positions[connection[1]]) <\
				flattened_room_positions[preferred_connection[0]].distance_squared_to(flattened_room_positions[preferred_connection[1]]):
					preferred_connection = connection

		# Add the new connection to our connected room variable, index at is set at 1, so we add the new connection
		connected_rooms.append(preferred_connection[1])

		# Lastly, we connect the new points in our mst graph and remove them from the delaunay graph, since we have them in our mst graph
		mst_graph.connect_points(preferred_connection[0], preferred_connection[1])
		delaunay_graph.disconnect_points(preferred_connection[0], preferred_connection[1])

	return mst_graph


## We now create the corridors in our gridmap.
## AStarGrid is used to find the shortest path between the rooms, to connect our corridors.
## For our AStarGrid we don't want to allow it to create diagonal corridors, so we set that to never.
## In which, we need to set the estimate heuristic to manhattan, since that only calculates horizontal and vertical steps, which we want.
func _process_corridors(corridors: Array[PackedVector3Array]) -> void:
	var astar_grid: AStarGrid2D = AStarGrid2D.new()

	astar_grid.region = Rect2i(Vector2i.ZERO, Vector2i.ONE * boundary_size) # Set the region to our boundary size
	astar_grid.update()
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	# Get the all the rooms inside our gridmap, 0 is the item key of room
	# We want to loop this and then set the points in our astar grid, so that we use it later
	for cell in grid_map.get_used_cells_by_item(0):
		astar_grid.set_point_solid(Vector2i(cell.x, cell.z))

	# Loop for all the corridor points that was given as a param
	# The used astargrid we now want to apply to get the paths between the two rooms, which will be used to calculate the shortest path 
	# Since we have a somewhat 3D dungeon generator, we need to convert those 2d points back to 3d, simply by just ignoring the Y axis
	for corridor in corridors:
		var start_position: Vector2 = Vector2(corridor[0].x, corridor[0].z)
		var end_position: Vector2 = Vector2(corridor[1].x, corridor[1].z)
		var pathway: PackedVector2Array = astar_grid.get_point_path(start_position, end_position)

		for point in pathway:
			var pos: Vector3 = Vector3(point.x, 0, point.y)

			# Make sure the cell is empty, so we don't place on cells that are already occupied
			if grid_map.get_cell_item(pos) < 0:
				grid_map.set_cell_item(pos, 1) # 1 is the item key for our corridor inside our GridMap
