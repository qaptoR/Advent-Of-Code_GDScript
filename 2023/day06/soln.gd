
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day06/test.txt"
    # "D:/Files/advent/2023/day06/data.txt"
    # "/Users/rocco/Programming/advent/2023/day06/data.txt"
    "/Users/rocco/Programming/advent/2023/day06/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex := RegEx.new()
    regex.compile(r'(\d+)')

    var data :Dictionary = {}
    var params :PackedStringArray = content.split("\n", false)
    var times = regex.search_all(params[0])
    var dists = regex.search_all(params[1])

    for i in times.size():
        data[i] = {
            time = times[i].get_string(),
            dist = dists[i].get_string(),
        }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 1

    for race in data:
        var time = data[race].time.to_int()
        var dist = data[race].dist.to_int()

        var qn = int(floor((time - sqrt(time **2 - 4 * dist)) /2))

        result *= time - (2 * qn) - 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var timestr = ''
    var diststr = ''

    for race in data:
        timestr += data[race].time
        diststr += data[race].dist

    var time = timestr.to_int()
    var dist = diststr.to_int()

    var qn = int(floor((time - sqrt(time **2 - 4 * dist)) /2))

    result = time - (2 * qn) - 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


