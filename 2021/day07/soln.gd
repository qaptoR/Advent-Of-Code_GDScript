
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day07/test.txt"
    "D:/Files/advent/2021/day07/data.txt"
    # "/Users/rocco/Programming/advent/2021/day07/data.txt"
    # "/Users/rocco/Programming/advent/2021/day07/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {
        'crabs': Array(content.strip_edges().split(',', false))
    }
    data.crabs = data.crabs.map(func(x): return int(x))

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var _min = data.crabs.min()
    var _max = data.crabs.max()

    var _positions :Array = []

    for i in range(_min, _max +1):
        var _fuel = 0
        for crab in data.crabs:
            _fuel += abs(crab - i)
        _positions.append(_fuel)

    result = _positions.min()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var _min = data.crabs.min()
    var _max = data.crabs.max()

    var _positions :Array = []

    for i in range(_min, _max +1):
        var _fuel = 0
        for crab in data.crabs:
            var _n = abs(crab - i)
            var _sum = (_n * (_n + 1)) / 2
            _fuel += _sum
        _positions.append(_fuel)

    result = _positions.min()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)

