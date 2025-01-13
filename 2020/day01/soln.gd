
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day01/test.txt"
    "D:/Files/advent/2020/day01/data.txt"
    # "/Users/rocco/Programming/advent/2020/day01/data.txt"
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

    for pair in ChooseR.new(data_, 2):
        var a = int(pair[0])
        var b = int(pair[1])
        if (a + b) != 2020: continue
        result = a * b
        break

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pair in ChooseR.new(data_, 3):
        var a = int(pair[0])
        var b = int(pair[1])
        var c = int(pair[2])
        if (a + b + c) != 2020: continue
        result = a * b * c
        break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


