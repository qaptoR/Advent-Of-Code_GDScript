
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day06/test.txt"
    "D:/Files/advent/2022/day06/data.txt"
    # "/Users/rocco/Programming/advent/2022/day06/data.txt"
    # "/Users/rocco/Programming/advent/2022/day06/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {
        lines = Array(content.split("\n", false))
    }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regex := RegEx.new()
    regex.compile(generate_regex(4))

    for line in data.lines:
        var match := regex.search(line)
        if match: print(match.get_end())

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regex := RegEx.new()
    regex.compile(generate_regex(14))

    for line in data.lines:
        var match := regex.search(line)
        if match: print(match.get_end())

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func generate_regex(n :int) -> String:
    var regex :String = '(?:(?!(.)\\1)(.))'
    for i in range(2, n +1):
        regex += '(?:(?!%s)(.))'
        var substr :String = '\\1'
        for j in range(2, i+1):
            substr += '|\\%d' %j
        regex = regex % substr

    return regex
