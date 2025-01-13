
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day03/test.txt"
    "D:/Files/advent/2020/day03/data.txt"
    # "/Users/rocco/Programming/advent/2020/day03/data.txt"
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

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split("", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var slope = Vector2i(3, 1)
    var pos = Vector2i(0, 0)
    while pos.y < data_.size():
        if data_[pos.y][pos.x % data_[0].size()] == '#':
            result += 1
        pos += slope

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 1
    var slopes = [
        Vector2i(1, 1),
        Vector2i(3, 1),
        Vector2i(5, 1),
        Vector2i(7, 1),
        Vector2i(1, 2)
    ]
    for slope in slopes:
        var trees = 0
        var pos = Vector2i(0, 0)
        while pos.y < data_.size():
            if data_[pos.y][pos.x % data_[0].size()] == '#':
                trees += 1
            pos += slope
        result *= trees

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


