
extends SceneTree

# data size: 10
# data solutions:
# Part 1 - 252594
# Part 2 - 3579328


const DATA_FILE = (
    "D:/Files/advent/2015/day10/day10.txt"
)

const DATA_STRING = "1113222113"


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 9!\n")

    # var data :Array = load_data(TEST_FILE)
    # var data :Array = load_data(DATA_FILE)
    var data :Array = [DATA_STRING]
    # width = data[0].size()
    # height = data.size()

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
    var data :Array = look_and_say(Array(data_[0].split("", false)), 40)

    result = data.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var data :Array = look_and_say(Array(data_[0].split("", false)), 50)

    result = data.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func look_and_say(data_ :Array, iter :int) -> Array:

    var data :Array = data_.duplicate(true)
    for i in range(iter):
        var new_data :Array = []
        var count :int = 0
        var value :String = data[0]
        for j in range(data.size()):
            if data[j] == value:
                count += 1
            else:
                new_data.append_array([str(count), value])
                count = 1
                value = data[j]
        new_data.append_array([str(count), value])
        data.assign(new_data)

    return data
