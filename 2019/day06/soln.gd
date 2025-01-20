
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2019/day06/test.txt"
    # "D:/Files/advent/2019/day06/data.txt"
    "/Users/rocco/Programming/advent/2019/day06/data.txt"
    # "/Users/rocco/Programming/advent/2019/day06/test.txt"
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

    var data :Dictionary = {'orbits': {}}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var objects  = line.split(")", false)
        data.orbits[objects[1]] = objects[0]

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for obj in data.orbits:
        var mass = data.orbits[obj]
        result += 1

        while mass != 'COM':
            result += 1
            mass = data.orbits[mass]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var path :Dictionary = {}

    var i :int = 0
    var mass = data.orbits['YOU']
    while mass != 'COM':
        i += 1
        path[mass] = i
        mass = data.orbits[mass]

    i = 0
    mass = data.orbits['SAN']
    while not path.has(mass) and mass != 'COM':
        i += 1
        mass = data.orbits[mass]

    result = i + path[mass] -1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


