
extends SceneTree

# data size: 8192
# data solutions:
# Part 1 - 2592
# Part 2 - 2360



const DATA_FILE = (
    "D:/Files/advent/2015/day03/day03.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 3!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

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

    var posz :Dictionary = {}
    var cur_pos :Vector2 = Vector2(0, 0)
    posz[cur_pos] = true

    for chare in data_[0]:
        var dir :Vector2
        match chare:
            '^': dir = Vector2(0, 1)
            'v': dir = Vector2(0, -1)
            '<': dir = Vector2(-1, 0)
            '>': dir = Vector2(1, 0)
        cur_pos = cur_pos + dir
        posz[cur_pos] = true

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', posz.size(), ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var posz :Dictionary = {}
    var santa_pos :Vector2 = Vector2(0, 0)
    var robo_pos :Vector2 = Vector2(0, 0)
    posz[santa_pos] = true

    var i :int = 0
    for chare in data_[0]:
        var dir :Vector2
        match chare:
            '^': dir = Vector2(0, 1)
            'v': dir = Vector2(0, -1)
            '<': dir = Vector2(-1, 0)
            '>': dir = Vector2(1, 0)
        match i:
            0: santa_pos = santa_pos + dir
            1: robo_pos = robo_pos + dir
        posz[santa_pos] = true
        posz[robo_pos] = true
        i = (i + 1) % 2


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', posz.size(), ' time: ', time_end - time_start)
