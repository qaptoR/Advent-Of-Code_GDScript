
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2016/day09/test1.txt"
    "D:/Files/advent/2016/day09/data.txt"
    # "/Users/rocco/Programming/advent/2016/day09/data.txt"
    # "/Users/rocco/Programming/advent/2016/day09/test.txt"
)

var regex = RegEx.create_from_string(r'\((\d+)x(\d+)\)')
var memo :Dictionary = {}


func _init() -> void:
    print("Saluton, Tago 09!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    data['lines'] = Array(lines)

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for line in data.lines:
        result += decompress(line).length()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for line in data.lines:
        result += rec_decompress(line)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func decompress(line :String) -> String:
    var decompressed :String = ''

    while line != '':
        var rematch = regex.search(line)
        if rematch:
            decompressed += line.substr(0, rematch.get_start(0))
            var length :int = int(rematch.get_string(1))
            var repeat :int = int(rematch.get_string(2))
            var repeat_str :String = line.substr(rematch.get_end(0), length)
            line = line.substr(rematch.get_end(0) + length)
            for i in repeat: decompressed += repeat_str
        else:
            decompressed += line
            line = ''

    return decompressed


func rec_decompress(line :String) -> int:

    if line in memo:
        return memo[line]

    var length :int = 0

    var rematch = regex.search(line)
    if rematch:
        length = rematch.get_start(0)
        var lengthgth :int = int(rematch.get_string(1))
        var repeat :int = int(rematch.get_string(2))
        var repeat_str :String = line.substr(rematch.get_end(0), lengthgth)
        var rest :String = line.substr(rematch.get_end(0) + lengthgth)
        length += repeat * rec_decompress(repeat_str)
        length += rec_decompress(rest)
    else:
        length += line.length()

    memo[line] = length
    return length
