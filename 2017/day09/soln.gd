
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2017/day09/test1.txt"
    "D:/Files/advent/2017/day09/data.txt"
    # "/Users/rocco/Programming/advent/2017/day09/data.txt"
    # "/Users/rocco/Programming/advent/2017/day09/test.txt"
)


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
    for line in lines.size():
        data[line] = Array(lines[line].split("", false))

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for key in data:
        var score = parse_stream(data[key].duplicate(true))
        # prints(key, score.score)
        result += score.score

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for key in data:
        var score = parse_stream(data[key].duplicate(true))
        # prints(key, score.chrs)
        result += score.chrs

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func parse_stream(stream :Array) -> Dictionary:
    var score   :int  = 0
    var chrs    :int  = 0
    var depth   :int  = 0
    var garbage :bool = false
    var ignore  :bool = false

    for chr in stream:
        match chr:
            '!' : ignore = !ignore
            '<' :
                if ignore: ignore = false
                elif garbage: chrs += 1
                else:
                    garbage = true
                    ignore = false
            '>' :
                if ignore: ignore = false
                else: garbage = false
            '{' :
                if ignore: ignore = false
                elif garbage: chrs += 1
                else: depth += 1
            '}' :
                if ignore: ignore = false
                elif garbage: chrs += 1
                else:
                    score += depth
                    depth -= 1
            ',' :
                if ignore: ignore = false
                elif garbage: chrs += 1
            _ :
                if ignore: ignore = false
                elif garbage: chrs += 1

    return {score = score, chrs = chrs}
