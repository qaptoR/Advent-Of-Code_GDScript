
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2017/day04/test04.txt"
    "D:/Files/advent/2017/day04/data04.txt"
)


func _init() -> void:
    print("Saluton, Tago 04!\n")

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
        data.append(Array(row.split(" ", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for row in data_:
        var flag = true
        for item in row: if row.count(item) > 1:
            flag = false
            break
        if flag: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for row in data_:
        var angrams = []
        for item in row:
            var word = item.split('', false)
            word.sort()
            angrams.append(''.join(word))

        var flag = true
        for item in angrams: if angrams.count(item) > 1:
            flag = false
            break
        if flag: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


