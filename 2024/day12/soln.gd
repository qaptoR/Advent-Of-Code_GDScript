
extends SceneTree

# testdata size: 10 x 10
# testdata solutions:
# Part 1 - 1930
# Part 2 - 1206

# data size: 140 x 140
# data solutions:
# Part 1 - 1363682
# Part 2 - ?


const TEST_FILE = (
    "D:/Files/advent/2024/day12/test12.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day12/data12.txt"
)


var height :int = 0
var width :int = 0

var directions :Array = [
    Vector2.UP,
    Vector2.RIGHT,
    Vector2.DOWN,
    Vector2.LEFT,
]

var diagonals :Array = [
    Vector2.UP + Vector2.RIGHT,
    Vector2.DOWN + Vector2.RIGHT,
    Vector2.DOWN + Vector2.LEFT,
    Vector2.UP + Vector2.LEFT,
]


func _init() -> void:
    print("Hello, Day 12!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    height = data.size()
    width = data[0].size()


    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split("", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var regions :Dictionary = {}
    populate_regions(data_, regions)

    for region in regions: for plot in regions[region]:
        var perimeter = get_perimeter(data_, plot)
        var area = plot.size()
        result += area * perimeter

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var regions :Dictionary = {}
    populate_regions(data_, regions)

    for region in regions: for plot in regions[region]:
        var sides = walk_perimeter(data_, plot)
        var area = plot.size()
        result += area * sides

    for i in range(0, regions.keys().size() -1):
        for j in range(i + 1, regions.keys().size()):
            var region1 = regions.keys()[i]
            var region2 = regions.keys()[j]
            for plot1 in regions[region1]:
                for plot2 in regions[region2]:
                    if a_inside_b(plot1, plot2):
                        var sides = walk_perimeter(data_, plot1)
                        var area = plot2.size()
                        result += area * sides
                    elif a_inside_b(plot2, plot1):
                        var sides = walk_perimeter(data_, plot2)
                        var area = plot1.size()
                        result += area * sides

    var resulte = 0
    for region in regions: for plot in regions[region]:
        var sides = count_corners(data_, plot)
        var area = plot.size()
        resulte += area * sides


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)
    print('part 2: ', resulte, ' time: ', time_end - time_start)


func populate_regions(data_ :Array, regions :Dictionary) -> void:

    for y in range(height): for x in range(width):
        var data = data_[y][x]
        if not data in regions:
            regions[data] = []

        var pos = Vector2(x, y)
        var visited :bool = false
        for plot in regions[data]:
            if pos in plot:
                visited = true
                break
        if visited: continue

        var new_plot :Dictionary = {pos: true}

        var frontier :Array = [pos]
        while frontier.size() > 0:
            var current = frontier.pop_back()
            for direction in directions:
                var new_pos = current + direction
                if new_pos.y < 0 or height <= new_pos.y: continue
                if new_pos.x < 0 or width <= new_pos.x: continue
                if data_[new_pos.y][new_pos.x] != data: continue
                if new_pos not in new_plot:
                    new_plot[new_pos] = true
                    frontier.append(new_pos)

        regions[data].append(new_plot)


func get_perimeter(data_ :Array, plot :Dictionary) -> int:

    var perimeter :int = 0
    for pos in plot:
        var data = data_[pos.y][pos.x]
        for direction in directions:
            var new_pos = pos + direction
            if new_pos.y < 0 or height <= new_pos.y: perimeter += 1
            elif new_pos.x < 0 or width <= new_pos.x: perimeter += 1
            elif data_[new_pos.y][new_pos.x] != data: perimeter += 1

    return perimeter

func count_corners(data_ :Array, plot :Dictionary) -> int:

    var sets :Array = [
        [Vector2(-1, 0), Vector2(0, -1), Vector2(-1, -1)],
        [Vector2(0, -1), Vector2(1, 0), Vector2(1, -1)],
        [Vector2(1, 0),  Vector2(0, 1), Vector2(1, 1)],
        [Vector2(0, 1),  Vector2(-1, 0), Vector2(-1, 1)],
    ]

    var corners :int = 0
    for pos in plot: for dirs in sets:
        if is_corner(data_, plot, pos, dirs):
            corners += 1

    return corners


func is_corner(data_ :Array, plot :Dictionary, pos :Vector2, dirs :Array) -> bool:

    var outside :bool = true
    for dir in dirs:
        var new_pos = pos + dir
        if new_pos in plot: outside = false

    var inside :bool = true
    for dir in dirs.size():
        var new_pos = pos + dirs[dir]
        if dir < (dirs.size() -1):
            if new_pos not in plot: inside = false
        else: if new_pos in plot: inside = false

    var special :bool = true
    for dir in dirs.size():
        var new_pos = pos + dirs[dir]
        if dir < (dirs.size() -1):
            if new_pos in plot: special = false
        else: if new_pos not in plot: special = false

    return outside or inside or special


func walk_perimeter(data_ :Array, plot :Dictionary) -> int:

    # find a corner
    var start_pos :Vector2
    for pos in plot:
        var flag :bool = true
        for direction in [Vector2.LEFT, Vector2.UP]:
            var new_pos = pos + direction
            if new_pos not in plot: continue
            flag = false
        if flag:
            start_pos = pos
            break

    var right_turn :Transform2D = Transform2D(deg_to_rad(90), Vector2(0, 0))
    var left_turn :Transform2D = Transform2D(deg_to_rad(-90), Vector2(0, 0))

    var direction :Vector2i = Vector2.RIGHT
    var looking :Vector2i = Vector2.UP

    var sides :int = 1
    var current_pos :Vector2 = start_pos
    while true: 
        var next_pos :Vector2 = current_pos + Vector2(direction)
        var look_at :Vector2 = current_pos + Vector2(looking)
        if next_pos not in plot:
            if look_at not in plot:
                direction = Vector2i(right_turn * Vector2(direction))
                looking = Vector2i(right_turn * Vector2(looking))
                sides += 1
            else:
                current_pos = look_at
                direction = Vector2i(left_turn * Vector2(direction))
                looking = Vector2i(left_turn * Vector2(looking))
                sides += 1
        else:
            if look_at not in plot:
                current_pos = next_pos
            else:
                current_pos = look_at
                direction = Vector2i(left_turn * Vector2(direction))
                looking = Vector2i(left_turn * Vector2(looking))
                sides += 1

        if current_pos == start_pos and direction == Vector2i.UP: break

    return sides

func a_inside_b(a :Dictionary, b :Dictionary) -> bool:

    for pos in a: for direction in (directions + diagonals):
        var flag :bool = true
        for i in height:
            var new_pos = pos + round(direction * i)
            if new_pos in a: continue
            if new_pos in b: flag = false
        if flag: return false

    return true
