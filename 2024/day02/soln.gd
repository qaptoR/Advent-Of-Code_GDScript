
extends SceneTree

# testdata size: 6
# testdata solutions:
# Part 1 - 2
# Part 2 - 4

# data size: 1000
# data solutions:
# Part 1 - 524
# Part 2 - 569


const TEST_FILE = (
    "D:/Files/advent/2024/day02/test02.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day02/data02.txt"
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
        data.append(Array(row.split(" ", false)))
    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var count :int = 0
    for row in data_:
        if rec_compare(row.duplicate(true), 0): count += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', count, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var count :int = 0
    for row in data_:
        if rec_compare(row.duplicate(true), 0):
            count += 1
        else: for i in range(row.size()):
            var row_copy :Array = row.duplicate(true)
            row_copy.remove_at(i)
            if rec_compare(row_copy, 0):
                count += 1
                break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', count, ' time: ', time_end - time_start)


func rec_compare(data_ :Array, inc_ :int) -> bool:

    if data_.size() == 1: return true

    var front = data_.pop_front().to_int()
    var next = data_[0].to_int()

    var diff = front - next
    var s :int = signi(diff)
    diff = abs(diff)

    if s == 0: return false
    if s != inc_ and inc_ != 0: return false
    if diff < 1 or 3 < diff: return false

    return rec_compare(data_, s)

