
extends SceneTree

# testdata size: 1
# testdata solutions:
# Part 1 - 6/22, 25/55312
# Part 2 - ?

# data size: 1
# data solutions:
# Part 1 - 200446
# Part 2 - 238317474993392


const TEST_FILE = (
    "D:/Files/advent/2024/day11/test11.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day11/data11.txt"
)


var width :int = 0
var height :int = 0

var cache :Dictionary = {}


func _init() -> void:
    print("Hello, Day 11!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

    for i in range(data.size()):
        data[i] = data[i].to_int()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    content = content.strip_edges()
    var data :PackedStringArray = content.split(" ", false)
    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var data = blink(data_, 25)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', data.size(), ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var count :int = 0
    for data in data_:
        # count += rec_blink(data, 25)
        count += rec_blink(data, 75)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', count, ' time: ', time_end - time_start)


func blink (data_ :Array, loops_ :int) -> Array:
    var data :Array = data_.duplicate(true)
    for k in range(loops_):
        var new_data :Array = []
        for i in range(data.size()):
            if data[i] == 0:
                new_data.append(1)
            elif str(data[i]).length() % 2 == 0:
                var strdata :String = str(data[i])
                new_data.append(strdata.substr(0, strdata.length() / 2).to_int())
                new_data.append(strdata.substr(strdata.length() / 2).to_int())
            else:
                new_data.append(data[i] * 2024)

        data.assign(new_data)

    return data


func rec_blink (data_ :int, depth_ :int) -> int:

    if depth_ == 0:
        return 1

    if cache.has([data_, depth_]):
        return cache[[data_, depth_]]

    var count :int = 0
    if data_ == 0:
        count += rec_blink(1, depth_ - 1)
    elif str(data_).length() % 2 == 0:
        var strdata_ :String = str(data_)
        count += rec_blink(strdata_.substr(0, strdata_.length() / 2).to_int(), depth_ - 1)
        count += rec_blink(strdata_.substr(strdata_.length() / 2).to_int(), depth_ - 1)
    else:
        count += rec_blink(data_ * 2024, depth_ - 1)

    cache[[data_, depth_]] = count
    return count

