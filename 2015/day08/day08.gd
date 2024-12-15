
extends SceneTree

# data size: 300
# data solutions:
# Part 1 - 1371
# Part 2 - 2117



const DATA_FILE = (
    "D:/Files/advent/2015/day08/day08.txt"
)


var width :int = 0
var height :int = 0

var memo :Dictionary = {}


func _init() -> void:
    print("Hello, Day 8!\n")

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

    var hexreg := RegEx.create_from_string(r'\\x[0-9a-f]{2}')
    var backreg := RegEx.create_from_string(r'\\"|\\\\')

    var result :int = 0
    for row in data_:
        var memlen :int = row.length() -2
        var hexes :int = hexreg.search_all(row).size()
        var backs :int = backreg.search_all(row).size()
        for i in hexes: memlen -= 3
        for i in backs: memlen -= 1

        result += row.length() - memlen

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    for row in data_:
        var esclen :int = row.c_escape().length() + 2
        result += esclen - row.length()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)

