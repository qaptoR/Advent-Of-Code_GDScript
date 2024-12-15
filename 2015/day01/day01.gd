
extends SceneTree

# data size: 7000
# data solutions:
# Part 1 - 74
# Part 2 - 1795



const DATA_FILE = (
    "D:/Files/advent/2015/day01/day01.txt"
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
        sum += row.count('(')
        sum -= row.count(')')

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var sum :int = 0

    for i in range(data_[0].length()):
        if data_[0][i] == '(': sum += 1
        else: sum -= 1
        if sum == -1:
            sum = i
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)
