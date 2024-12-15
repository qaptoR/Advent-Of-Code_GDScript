
extends SceneTree

# testdata size: 1
# testdata solutions:
# Part 1 - 161
# Part 2 - 48

# data size: 6
# data solutions:
# Part 1 - 170068701
# Part 2 - 78683433


const TEST_FILE = (
    "D:/Files/advent/2024/day03/test03.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day03/data03.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 3!\n")

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

    var mulreg = RegEx.create_from_string(r'mul\(\d{1,3},\d{1,3}\)')
    var numreg = RegEx.create_from_string(r'\d{1,3}')

    var sum :int = 0
    for row in data_:
        var matches = mulreg.search_all(row)
        for match in matches:
            var nums = numreg.search_all(match.strings[0])
            sum += int(nums[0].strings[0]) * int(nums[1].strings[0])


    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var mulreg = RegEx.create_from_string(
        r"""mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)"""
    )
    var numreg = RegEx.create_from_string(r'\d{1,3}')

    var sum :int = 0
    var flag :bool = false
    for row in data_:
        var matches = mulreg.search_all(row)
        for match in matches:
            if match.strings[0] == 'do()':
                flag = false
                continue
            elif match.strings[0] == 'don\'t()':
                flag = true
                continue
            if flag: continue

            var nums = numreg.search_all(match.strings[0])
            sum += int(nums[0].strings[0]) * int(nums[1].strings[0])

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)

