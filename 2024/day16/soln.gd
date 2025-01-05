
extends SceneTree

# testdata solutions:
# Part 1 - 7036, 11048
# Part 2 - 45, 64

# data solutions:
# Part 1 - 114476
# Part 2 - 477


const DATA_FILE = (
    # "D:/Files/advent/2024/day16/maze01.txt"
    # "D:/Files/advent/2024/day16/maze02.txt"
    "D:/Files/advent/2024/day16/data16.txt"
)


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Hello, Day 16!\n")

    var data :Array = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n", false)

    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var map :Dictionary = {}
    var start :Vector2i = Vector2i(0, 0)
    var end :Vector2i = Vector2i(0, 0)
    for row in data_.size():
        var row_data :PackedStringArray = data_[row].split("", false)
        for cell in row_data.size():
            if row_data[cell] == 'E': end = Vector2i(cell, row)
            if row_data[cell] == 'S': start = Vector2i(cell, row)
            map[Vector2i(cell, row)] = row_data[cell]

    var direction := Vector2i.RIGHT
    result = dijkstra(map, start, end, direction)[0][end]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var resulte = 0
    var map :Dictionary = {}
    var start :Vector2i = Vector2i(0, 0)
    var end :Vector2i = Vector2i(0, 0)
    for row in data_.size():
        var row_data :PackedStringArray = data_[row].split("", false)
        for cell in row_data.size():
            if row_data[cell] == 'E': end = Vector2i(cell, row)
            if row_data[cell] == 'S': start = Vector2i(cell, row)
            map[Vector2i(cell, row)] = row_data[cell]

    var direction := Vector2i.RIGHT
    var dicts = dijkstra(map, start, end, direction)
    dicts.append(map)
    resulte = traverse_best_paths(dicts, start, end)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', resulte, ' time: ', time_end - time_start)


func dijkstra(
    map :Dictionary,
    start :Vector2i, end :Vector2i, direction :Vector2i,
) -> Array:
    var distances :Dictionary = {}
    var previous :Dictionary = {}
    var visited :Array = []
    var queue :Array = []

    for node in map.keys():
        if map[node] == '#': continue
        distances[node] = (2 ** 63) -1
        previous[node] = null

    distances[start] = 0

    queue.append([start, direction, 0])
    while queue.size() > 0:
        queue.sort_custom(func(a, b): return a[2] < b[2])
        var current :Vector2i = queue[0][0]
        var current_distance :int = queue[0][2]
        var current_direction :Vector2i = queue[0][1]
        queue.remove_at(0)

        if current == end: break

        if current in visited: continue
        visited.append(current)

        for neighbor in neighbors(map, current, current_direction):
            if neighbor[0] in visited: continue

            var weight :int = neighbor[2]
            var distance :int = current_distance + weight

            if distance < distances[neighbor[0]]:
                distances[neighbor[0]] = distance
                previous[neighbor[0]] = current
                queue.append([neighbor[0], neighbor[1], distance])

    return [distances, previous]


func neighbors (map :Dictionary, node :Vector2i, direction :Vector2i) -> Array:

    var neighbors :Array = []

    const right_turn := Transform2D(deg_to_rad(90), Vector2.ZERO)
    const left_turn := Transform2D(deg_to_rad(-90), Vector2.ZERO)

    var dir :Vector2i = direction
    var look_at :Vector2i = node + dir
    if map.has(look_at) and map[look_at] != '#':
        neighbors.append([look_at, direction, 1])

    var turns :Array = [left_turn, right_turn]
    for turn in turns.size():
        dir = direction
        var count :int = 0
        for i in range(2 - turn):
            count += 1000
            dir = Vector2i(turns[turn] * Vector2(dir))
            look_at = node + dir
            if map[look_at] != '#':
                neighbors.append([look_at, dir, count + 1])

    return neighbors


func traverse_best_paths(dicts :Array, start :Vector2i, end :Vector2i) -> int:

    var juncts :Array = []
    var best_nodes :Dictionary = {}
    var visited :Array = []

    var current :Vector2i = end
    var last_direction :Vector2i = Vector2i.ZERO

    while true:

        if current == start:
            if len(juncts) > 0:
                current = juncts.pop_back()
                visited.append(current)
            else: break

        best_nodes[current] = true

        var previous_best :Vector2i = dicts[1][current]
        var curr_direction :Vector2i = current - previous_best
        best_nodes[previous_best] = true
        var best_distance = dicts[0][previous_best]

        for neighbor in junctions(dicts[2], current):
            var direction :Vector2i = current - neighbor
            if neighbor == previous_best: continue
            var distance = dicts[0][neighbor]
            if direction == last_direction: distance -= 1000
            if distance == best_distance:
                juncts.append(neighbor)

        current = previous_best
        last_direction = curr_direction

    return best_nodes.size()


func junctions(map :Dictionary, node :Vector2i) -> Array:

    var juncts :Array = []

    var directions :Array = [
        Vector2i.RIGHT,
        Vector2i.DOWN,
        Vector2i.LEFT,
        Vector2i.UP,
    ]

    for direction in directions.size():
        var look_at :Vector2i = node + directions[direction]
        if map[look_at] != '#':
            juncts.append(look_at)

    return juncts


