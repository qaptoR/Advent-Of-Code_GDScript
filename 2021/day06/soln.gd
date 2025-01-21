
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day06/test.txt"
    "D:/Files/advent/2021/day06/data.txt"
    # "/Users/rocco/Programming/advent/2021/day06/data.txt"
    # "/Users/rocco/Programming/advent/2021/day06/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

    var data :Dictionary = load_data(DATA_FILE)

    # test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data = {'fish': content.strip_edges().split(",", false)}

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    const DAYS = 80

    var result = 0
    var id = 0
    var school :Dictionary = {}

    for fish in data.fish:
        school[id] = fish.to_int()
        id += 1

    for i in range(DAYS):
        var current_school = school.keys()
        for fish in current_school:
            if school[fish] == 0:
                school[fish] = 6
                school[id] = 8
                id += 1
            else: school[fish] -= 1

    result = school.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    const DAYS = 256

    var result = 0
    var school :Array = []

    for fish in data.fish: school.append(fish.to_int())

    var memo :Dictionary = {}
    for fish in school:
        result += rec_expand(fish, DAYS, memo)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func rec_expand(curr :int, day :int, memo :Dictionary) -> int:

    if memo.has([curr, day]): return memo[[curr, day]]

    if day == 0: return 1

    var cfish = 0
    var nfish = 0
    if curr == 0:
        cfish = rec_expand(6, day - 1, memo)
        nfish = rec_expand(8, day - 1, memo)
        memo[[curr, day]] = cfish + nfish
    else:
        cfish = rec_expand(curr - 1, day - 1, memo)
        memo[[curr, day]] = cfish

    return cfish + nfish

