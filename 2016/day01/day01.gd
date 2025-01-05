
extends SceneTree

# data solutions:
# Part 1 - 307
# Part 2 - 165


const DATA_FILE = (
    # "D:/Files/advent/2016/day01/test01.txt"
    "D:/Files/advent/2016/day01/data01.txt"
)


enum DIRS { UP, RIGHT, DOWN, LEFT }
var dirs :Array = [
    Vector2i(0, 1),
    Vector2i(1, 0),
    Vector2i(0, -1),
    Vector2i(-1, 0),
]


func _init() -> void:
    print("Saluton, Tago 01!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.split(", ", false)

    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var direction = 0
    var position = Vector2i(0, 0)

    for move in data_:
        var dir :String = move[0]
        var dist := int(move.substr(1))

        match dir:
            'R': direction = (direction + 1) % dirs.size()
            'L': direction = (direction - 1) % dirs.size()

        for i in range(dist):
            position += dirs[direction]

    result = abs(position.x) + abs(position.y)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var direction = 0
    var position = Vector2i(0, 0)
    var visited :Dictionary = {position: true}

    for move in data_:
        var dir :String = move[0]
        var dist := int(move.substr(1))

        match dir:
            'R': direction = (direction + 1) % dirs.size()
            'L': direction = (direction - 1) % dirs.size()

        var flag = false
        for i in range(dist):
            position += dirs[direction]
            if visited.get(position, false):
                flag = true
                break
            else: visited[position] = true
        if flag: break

    result = abs(position.x) + abs(position.y)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


