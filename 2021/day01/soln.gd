
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day01/test.txt"
    "D:/Files/advent/2021/day01/data.txt"
    # "/Users/rocco/Programming/advent/2021/day01/data.txt"
)


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

    var data :PackedStringArray = content.split("\n", false)

    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for i in range(data_.size() -1):
        var a = int(data_[i])
        var b = int(data_[i+1])
        if a < b: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var prev = 2 ** 63 -1
    for i in range(data_.size() -2):
        var a = int(data_[i])
        var b = int(data_[i+1])
        var c = int(data_[i+2])
        var sum = a + b + c
        if prev < sum: result += 1
        prev = sum

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


