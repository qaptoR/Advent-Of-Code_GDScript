
extends SceneTree

# testdata size: 6
# testdata solutions:
# Part 1 - 11
# Part 2 - 31

# data size: 1000
# data solutions:
# Part 1 - 2970687
# Part 2 - 23963899


const TEST_FILE = (
    "D:/Files/advent/2024/day01/test01.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day01/data01.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 2!\n")

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

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split("   ", false)))
    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var sum :int = 0
    var lists :Array = [[], []]
    for row in data_:
        lists[0].append(row[0].to_int())
        lists[1].append(row[1].to_int())

    for i in range(height):
        var a :int = lists[0].min()
        lists[0].erase(a)

        var b :int = lists[1].min()
        lists[1].erase(b)

        sum += abs(a - b)


    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var sum :int = 0
    var lists :Array = [[], []]
    for row in data_:
        lists[0].append(row[0].to_int())
        lists[1].append(row[1].to_int())

    for i in range(height):
        var a :int = lists[0][i]
        var b :int = lists[1].count(a)

        sum += a * b

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)
