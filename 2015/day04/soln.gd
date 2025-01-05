
extends SceneTree

# data size: 1
# data solutions:
# Part 1 - 282749
# Part 2 - 9962624



const DATA_FILE = (
    "D:/Files/advent/2015/day04/day04.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 4!\n")

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

    var salte :int = 0
    var seede :String = data_[0]
    for i in range(1_000_000_000):
        var salt :String = seede + str(i)
        var mdfive :String = salt.md5_text()
        var substr :String = mdfive.substr(0, 5)

        if substr.count('0') == 5:
            salte = i
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', salte, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var salte :int = 0
    var seede :String = data_[0]
    for i in range(1_000_000_000):
        var salt :String = seede + str(i)
        var mdfive :String = salt.md5_text()
        var substr :String = mdfive.substr(0, 6)

        if substr.count('0') == 6:
            salte = i
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', salte, ' time: ', time_end - time_start)
