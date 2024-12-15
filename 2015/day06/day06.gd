
extends SceneTree

# data size: 300
# data solutions:
# Part 1 - 400410
# Part 2 - 15343601



const DATA_FILE = (
    "D:/Files/advent/2015/day06/day06.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 6!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

    # test_data1(data)
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

    var lights :Array = []
    for i in range(1000):
        lights.append([])
        lights[i].resize(1000)
        lights[i].fill(false)

    var rectex = RegEx.create_from_string(r'(\d{1,3}),(\d{1,3})')
    var intructex = RegEx.create_from_string(r'(turn on|turn off|toggle)')

    for row in data_:
        var rect :Array = rectex.search_all(row)
        var intruct :RegExMatch = intructex.search(row)

        var tl := Array(rect[0].get_string().split(',', false))
        var br := Array(rect[1].get_string().split(',', false))

        for x in range(tl[0].to_int(), br[0].to_int() + 1):
            for y in range(tl[1].to_int(), br[1].to_int() + 1):
                match intruct.get_string():
                    'turn on':
                        lights[x][y] = true
                    'turn off':
                        lights[x][y] = false
                    'toggle':
                        lights[x][y] = not lights[x][y]

    var sum :int = 0
    for row in lights:
        sum += row.count(true)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', sum, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var lights :Array = []
    for i in range(1000):
        lights.append([])
        lights[i].resize(1000)
        lights[i].fill(0)

    var rectex = RegEx.create_from_string(r'(\d{1,3}),(\d{1,3})')
    var intructex = RegEx.create_from_string(r'(turn on|turn off|toggle)')

    for row in data_:
        var rect :Array = rectex.search_all(row)
        var intruct :RegExMatch = intructex.search(row)

        var tl := Array(rect[0].get_string().split(',', false))
        var br := Array(rect[1].get_string().split(',', false))

        for x in range(tl[0].to_int(), br[0].to_int() + 1):
            for y in range(tl[1].to_int(), br[1].to_int() + 1):
                match intruct.get_string():
                    'turn on':
                        lights[x][y] = lights[x][y] + 1
                    'turn off':
                        lights[x][y] = max(0, lights[x][y] - 1)
                    'toggle':
                        lights[x][y] = lights[x][y] + 2

    var sum :int = 0
    for row in lights:
        sum += row.reduce(func(acc, x): return acc + x, 0)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', sum, ' time: ', time_end - time_start)
