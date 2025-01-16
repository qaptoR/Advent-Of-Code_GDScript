
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day01/test.txt"
    "D:/Files/advent/2023/day01/data.txt"
    # "/Users/rocco/Programming/advent/2023/day01/data.txt"
    # "/Users/rocco/Programming/advent/2023/day01/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 01!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {
        lines = content.split("\n", false),
    }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var exfirst = RegEx.new()
    var exlast = RegEx.new()
    exfirst.compile(r'^.*?(\d).*$')
    exlast.compile(r'^.*(\d).*?$')

    for line in data.lines:
        var first :RegExMatch = exfirst.search(line)
        var last :RegExMatch = exlast.search(line)
        var num :String = first.get_string(1) + last.get_string(1)
        result += int(num)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var words :PackedStringArray = [
        'one', 'two', 'three',
        'four', 'five', 'six',
        'seven', 'eight', 'nine',
    ]
    var opts :String = '|'.join(words)

    var map :Dictionary = {}
    for i in range(words.size()): map[words[i]] = str(i + 1)

    var exfirst = RegEx.new()
    var exlast = RegEx.new()
    exfirst.compile(r'^.*?(%s|\d).*$' % opts)
    exlast.compile(r'^.*(%s|\d).*?$' % opts)

    for line in data.lines:
        var first :RegExMatch = exfirst.search(line)
        var last :RegExMatch = exlast.search(line)
        var num :String = ''
        num += map[first.get_string(1)] if first.get_string(1)  in words else first.get_string(1)
        num += map[last.get_string(1)] if last.get_string(1)  in words else last.get_string(1)
        result += int(num)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


