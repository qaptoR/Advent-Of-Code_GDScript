
extends SceneTree

# data size: 1000
# data solutions:
# Part 1 - 1586300
# Part 2 - 3737498



const DATA_FILE = (
    "D:/Files/advent/2015/day02/day02.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 1!\n")

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

    var sum :int = 0
    for row in data_:
        var dims :Array = row.split("x", false)
        var l :int = int(dims[0])
        var w :int = int(dims[1])
        var h :int = int(dims[2])

        sum += 2*l*w + 2*w*h + 2*h*l + min(l*w, w*h, h*l)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var sum :int = 0
    for row in data_:
        var dims :Array = row.split("x", false)
        var l :int = int(dims[0])
        var w :int = int(dims[1])
        var h :int = int(dims[2])
        var per = min(2*l+2*w, 2*w+2*h, 2*h+2*l)
        var bow = l*w*h

        sum += per + bow

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)
