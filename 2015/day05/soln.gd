
extends SceneTree

# data size: 1000
# data solutions:
# Part 1 - 236
# Part 2 - 51



const DATA_FILE = (
    "D:/Files/advent/2015/day05/day05.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 5!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n", false)
    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var vowels := RegEx.create_from_string(r'[aeiou]')
    var bads := RegEx.create_from_string(r'ab|cd|pq|xy')
    var doubles := RegEx.create_from_string(r'(.)\1')

    var sum :int = 0
    for row in data_:
        var v :Array = vowels.search_all(row)
        var b :RegExMatch = bads.search(row)
        var d :RegExMatch = doubles.search(row)

        if v.size() < 3: continue
        if not d: continue
        if b: continue

        sum += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var doubles := RegEx.create_from_string(r'(..).*\1')
    var surround := RegEx.create_from_string(r'(.).\1')

    var sum :int = 0
    for row in data_:
        var d :RegExMatch = doubles.search(row)
        var s :RegExMatch = surround.search(row)

        if not d: continue
        if not s: continue

        sum += 1


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)
