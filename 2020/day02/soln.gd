
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day02/test.txt"
    "D:/Files/advent/2020/day02/data.txt"
    # "/Users/rocco/Programming/advent/2020/day02/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 02!\n")

    var data :Array = load_data(DATA_FILE)

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
        var package :Dictionary = {}

        var parts :PackedStringArray = row.split(": ", false)
        package['pwd'] = parts[1]

        parts = parts[0].split(" ", false)
        package['char'] = parts[1]

        parts = parts[0].split("-", false)
        package['min'] = parts[0].to_int()
        package['max'] = parts[1].to_int()

        data.append(package)

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pkg in data_:
        var count = pkg['pwd'].count(pkg['char'])
        if pkg['min'] <= count and count <= pkg['max']:
            result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pkg in data_:
        var charx = pkg['pwd'][pkg['min'] - 1]
        var chary = pkg['pwd'][pkg['max'] - 1]
        var boolx = charx == pkg['char']
        var booly = chary == pkg['char']
        var xor = (boolx or booly) and not (boolx and booly)
        if xor: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


