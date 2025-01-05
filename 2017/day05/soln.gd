
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2017/day05/test05.txt"
    "D:/Files/advent/2017/day05/data05.txt"
)


func _init() -> void:
    print("Saluton, Tago 05!\n")

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
    var instx :Array[int] = []
    for i in data_: instx.append(int(i))

    var index = 0
    while 0 <= index and index < instx.size():
        var jump = instx[index]
        instx[index] += 1
        index += jump
        result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var instx :Array[int] = []
    for i in data_: instx.append(int(i))

    var index = 0
    while 0 <= index and index < instx.size():
        var jump = instx[index]
        if  jump >= 3: instx[index] -= 1
        else: instx[index] += 1
        index += jump
        result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


