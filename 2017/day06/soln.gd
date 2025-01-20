
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2017/day06/test.txt"
    "D:/Files/advent/2017/day06/data.txt"
    # "/Users/rocco/Programming/advent/2017/day06/data.txt"
    # "/Users/rocco/Programming/advent/2017/day06/test.txt"
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

    var data :Dictionary = {}
    data['nums'] = []
    for n in content.strip_edges().split(" ", false):
        data['nums'].append(n.to_int())

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var patterns = {data.nums: true}
    var n_banks = data.nums.size()

    while true:
        result += 1
        var max_n = data.nums.max()
        var bank = data.nums.find(max_n)
        var dist :int = data.nums[bank] / n_banks
        if dist == 0: dist = 1

        var i = bank +1
        while data.nums[bank] >= dist:
            data.nums[i % n_banks] += dist
            data.nums[bank] -= dist
            i = (i +1) % n_banks

        if patterns.get(data.nums, false):
            break
        else: patterns[data.nums] = true

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var patterns = {data.nums: result}
    var n_banks = data.nums.size()

    while true:
        result += 1
        var max_n = data.nums.max()
        var bank = data.nums.find(max_n)
        var dist :int = data.nums[bank] / n_banks
        if dist == 0: dist = 1

        var i = bank +1
        while data.nums[bank] >= dist:
            data.nums[i % n_banks] += dist
            data.nums[bank] -= dist
            i = (i +1) % n_banks

        if patterns.get(data.nums, -1) >= 0:
            break
        else: patterns[data.nums] = result

    result = result - patterns[data.nums]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


