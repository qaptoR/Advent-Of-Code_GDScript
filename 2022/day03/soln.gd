
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day03/test.txt"
    "D:/Files/advent/2022/day03/data.txt"
    # "/Users/rocco/Programming/advent/2022/day03/data.txt"
    # "/Users/rocco/Programming/advent/2022/day03/test.txt"
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

    for pack in data_:
        var mid = pack.length()/2
        var sec1 = pack.substr(0, mid)
        var sec2 = pack.substr(mid, pack.length())
        for char in sec1: if char in sec2:
            result += get_priority(char)
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pack in range(0, data_.size(), 3):
        for chr in data_[pack]:
            if chr in data_[pack +1] and chr in data_[pack +2]:
                result += get_priority(chr)
                break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_priority(chr :String) -> int:

    var unicode = chr.to_lower().unicode_at(0)
    var p = unicode - 0x60
    if chr.to_lower() != chr: p += 26
    return p
