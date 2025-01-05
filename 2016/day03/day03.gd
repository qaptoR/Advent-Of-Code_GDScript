
extends SceneTree

# Part 1 - 862
# Part 2 - 1577

const DATA_FILE = (
    # "D:/Files/advent/2016/day03/test03.txt"
    "D:/Files/advent/2016/day03/data03.txt"
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
        data.append(Array(row.split("  ", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for row in data_:
        var a = int(row[0])
        var b = int(row[1])
        var c = int(row[2])
        if a + b > c and a + c > b and b + c > a:
            result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for row in range(0, data_.size(), 3):
        for i in range(3):
            var a = int(data_[row][i])
            var b = int(data_[row+1][i])
            var c = int(data_[row+2][i])
            if a + b > c and a + c > b and b + c > a:
                result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


