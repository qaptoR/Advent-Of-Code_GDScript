
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2099/day00/test.txt"
    "D:/Files/advent/2099/day00/data.txt"
    # "/Users/rocco/Programming/advent/2099/day00/data.txt"
    # "/Users/rocco/Programming/advent/2099/day00/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 00!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        data.get_or_add('chars', []).append(Array(line.split("", false)))

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


