
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day03/test.txt"
    # "D:/Files/advent/2021/day03/data.txt"
    # "/Users/rocco/Programming/advent/2021/day03/test.txt"
    "/Users/rocco/Programming/advent/2021/day03/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 03!\n")

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
    var gamma :String = ''
    var epsilon :String = ''

    for col in data_[0].length():
        var counts :Dictionary = {'0': 0, '1': 0}
        for row in data_:
            counts[row[col]] += 1
        gamma += counts.keys().reduce(func(acc, x): return acc if counts[acc] > counts[x] else x)
        epsilon += counts.keys().reduce(func(acc, x): return acc if counts[acc] < counts[x] else x)

    result = gamma.bin_to_int() * epsilon.bin_to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var oxylist :Array = data_.duplicate(true)
    var col :int = 0
    while oxylist.size() > 1 and col < data_[0].length():
        var counts :Dictionary = {'0': 0, '1': 0}
        for row in oxylist:
            counts[row[col]] += 1
        var max_key = counts.keys().reduce(func(acc, x): return acc if counts[acc] > counts[x] else x)
        max_key = '1' if counts['1'] == counts['0'] else max_key
        oxylist = oxylist.filter(func(x): return x[col] == max_key)
        col += 1

    var cotlist :Array = data_.duplicate(true)
    col = 0
    while cotlist.size() > 1 and col < data_[0].length():
        var counts :Dictionary = {'0': 0, '1': 0}
        for row in cotlist:
            counts[row[col]] += 1
        var max_key = counts.keys().reduce(func(acc, x): return acc if counts[acc] < counts[x] else x)
        max_key = '0' if counts['1'] == counts['0'] else max_key
        cotlist = cotlist.filter(func(x): return x[col] == max_key)
        col += 1

    result = oxylist[0].bin_to_int() * cotlist[0].bin_to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


