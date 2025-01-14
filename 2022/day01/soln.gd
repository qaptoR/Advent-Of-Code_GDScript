
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day01/test.txt"
    # "D:/Files/advent/2022/day01/data.txt"
    "/Users/rocco/Programming/advent/2022/day01/data.txt"
    # "/Users/rocco/Programming/advent/2022/day01/test.txt"
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

    var data :Array = []
    var lines :PackedStringArray = content.split("\n\n", false)
    for line in lines:
        data.append(Array(line.split("\n", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var pack_totals :Array = []

    for elf in data_:
        var pack_total = 0
        for pack in elf:
            pack_total += int(pack)

        pack_totals.append(pack_total)

    result = pack_totals.max()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var pack_totals :Array = []

    for elf in data_:
        var pack_total = 0
        for pack in elf:
            pack_total += int(pack)

        pack_totals.append(pack_total)

    for i in 3:
        var max = pack_totals.max()
        pack_totals.erase(max)
        result += max

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


