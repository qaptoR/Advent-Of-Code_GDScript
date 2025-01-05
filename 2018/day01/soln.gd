
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2018/day01/test01.txt"
    "D:/Files/advent/2018/day01/data01.txt"
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
    for i in data_:
        result += int(i)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


