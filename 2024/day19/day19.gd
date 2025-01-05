
extends SceneTree

# testdata solutions:
# Part 1 - 6
# Part 2 - 16

# data solutions:
# Part 1 - ?
# Part 2 - ?



const DATA_FILE = (
    # "D:/Files/advent/2024/day19/test19.txt"
    "D:/Files/advent/2024/day19/data19.txt"
)


var height :int = 0
var width :int = 0

var cache :Dictionary = {}


func _init() -> void:
    print("Hello, Day 19!\n")

    var data :Array = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()


    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n\n", false)

    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var towels := Array(data_[0].split(", ", false))
    var patterns := Array(data_[1].split("\n", false))

    result = patterns.reduce(func(count, pattern) -> int:
        var new_count = process(pattern, towels)
        return count + (1 if new_count > 0 else 0)
    , 0)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var towels := Array(data_[0].split(", ", false))
    var patterns := Array(data_[1].split("\n", false))

    result = patterns.reduce(func(count, pattern) -> int:
        return count + process(pattern, towels)
    , 0)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func process (pattern :String, towels :Array) -> int:
    if pattern.length() == 0: return 1

    if pattern in cache: return cache[pattern]

    var matched_towels = towels.filter(func(towel): return pattern.begins_with(towel))
    if matched_towels.size() == 0:
        cache[pattern] = 0
        return 0

    var total_count = matched_towels.reduce(func(count, towel) -> int:
        var new_pattern = pattern.substr(towel.length())
        return count + process(new_pattern, towels)
    , 0)

    cache[pattern] = total_count
    return total_count


