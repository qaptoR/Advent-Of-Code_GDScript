
extends SceneTree

# testdata size: ?
# testdata solutions:
# Part 1 - ?
# Part 2 - ?

# data size: ?
# data solutions:
# Part 1 - ?
# Part 2 - ?


const TEST_FILE = (
    "D:/Files/advent/2024/day14/test14.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day14/data14.txt"
)

const OUTFOLDER = "D:/Downloads/output/"
const OUTFILE = "day14_output_%s.png"


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Hello, Day 14!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()


    test_data1(data)
    # test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n", false)

    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var robotex = RegEx.create_from_string(r'.=(-?\d+),(-?\d+)')
    const seconds :int = 100
    var result :int = 0
    var data :Array = data_.duplicate(true)

    var room_text :String = data.pop_front()
    var room_size :RegExMatch = robotex.search(room_text)
    var room_vector := Vector2i(int(room_size.get_string(1)), int(room_size.get_string(2)))

    var robots :Array = []
    for row in data:
        var vectors :Array[RegExMatch] = robotex.search_all(row)
        robots.append([
            Vector2i(int(vectors[0].get_string(1)), int(vectors[0].get_string(2))),
            Vector2i(int(vectors[1].get_string(1)), int(vectors[1].get_string(2))),
        ])

    var room :Array[Array] = []
    for i in range(room_vector.y):
        room.append([])
        room[i].resize(room_vector.x)
        room[i].fill(0)

    for robot in robots:
        var pos :Vector2i = robot[0] + seconds * robot[1]
        pos.x = posmod(pos.x, room_vector.x)
        pos.y = posmod(pos.y, room_vector.y)
        room[pos.y][pos.x] += 1

    # for row in room.size():
    #     for cell in room[row].size():
    #         printraw(room[row][cell])
    #     print()

    var quadrants :Array[int] = [0, 0, 0, 0]
    for row in room.size():
        for cell in room[row].size():
            var quadrant :int = get_quadrant(room_vector, Vector2i(cell, row))
            if quadrant == -1: continue
            quadrants[quadrant] += room[row][cell]

    result = quadrants.reduce(func(acc, x): return acc * x, 1)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var robotex = RegEx.create_from_string(r'.=(-?\d+),(-?\d+)')
    const seconds :int = 100
    var result :int = 0
    var data :Array = data_.duplicate(true)

    var room_text :String = data.pop_front()
    var room_size :RegExMatch = robotex.search(room_text)
    var room_vector := Vector2i(int(room_size.get_string(1)), int(room_size.get_string(2)))

    var robots :Array = []
    for row in data:
        var vectors :Array[RegExMatch] = robotex.search_all(row)
        robots.append([
            Vector2i(int(vectors[0].get_string(1)), int(vectors[0].get_string(2))),
            Vector2i(int(vectors[1].get_string(1)), int(vectors[1].get_string(2))),
        ])

    var room :Array[Array] = []
    for i in range(room_vector.y):
        room.append([])
        room[i].resize(room_vector.x)
        room[i].fill(0)

    for i in range(seconds ** 2):
        var outfile :String = OUTFOLDER + OUTFILE % str(i)
        var image :Image = Image.create(
            room_vector.x, room_vector.y, false, Image.FORMAT_RGBA8
        )

        for robot in robots:
            var pos :Vector2i = robot[0] + i * robot[1]
            pos.x = posmod(pos.x, room_vector.x)
            pos.y = posmod(pos.y, room_vector.y)
            room[pos.y][pos.x] += 1

        for row in room.size():
            for cell in room[row].size():
                if room[row][cell] == 0: image.set_pixel(cell, row, Color(0, 0, 0, 1))
                else: image.set_pixel(cell, row, Color(1, 1, 1, 1))
                room[row][cell] = 0

        image.save_png(outfile)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_quadrant(room :Vector2i, pos :Vector2i) -> int:
    var half_x :int = room.x / 2
    var half_y :int = room.y / 2

    var quadrant :int = -1
    if pos.x < half_x:
        if pos.y < half_y: quadrant = 0
        elif half_y < pos.y: quadrant = 2
    elif half_x < pos.x:
        if pos.y < half_y: quadrant = 1
        elif half_y < pos.y: quadrant = 3

    return quadrant
