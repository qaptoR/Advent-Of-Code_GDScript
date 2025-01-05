
extends SceneTree

# Part 1 - zcreqgiv
# Part 2 - pljvorrk

const DATA_FILE = (
    # "D:/Files/advent/2016/day06/test06.txt"
    "D:/Files/advent/2016/day06/data06.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

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

    var result = ''
    var columns = []
    for row in data_.size(): for col in data_[row].size():
        if columns.size() == col: columns.append([])
        columns[col].append(data_[row][col])

    for col in columns:
        var counts = {}
        for c in col:
            if counts.get(c, 0) == 0:
                counts[c] = col.count(c)
            else: continue
        var keys = counts.keys()
        keys.sort_custom(func(a, b): return counts[a] > counts[b])
        result += keys[0]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''
    var columns = []
    for row in data_.size(): for col in data_[row].size():
        if columns.size() == col: columns.append([])
        columns[col].append(data_[row][col])

    for col in columns:
        var counts = {}
        for c in col:
            if counts.get(c, 0) == 0:
                counts[c] = col.count(c)
            else: continue
        var keys = counts.keys()
        keys.sort_custom(func(a, b): return counts[a] < counts[b])
        result += keys[0]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


