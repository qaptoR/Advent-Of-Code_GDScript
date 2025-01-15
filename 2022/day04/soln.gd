
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day04/test.txt"
    # "D:/Files/advent/2022/day04/data.txt"
    "/Users/rocco/Programming/advent/2022/day04/data.txt"
    # "/Users/rocco/Programming/advent/2022/day04/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 04!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex :RegEx = RegEx.new()
    regex.compile(r'(\d+)-(\d+),(\d+)-(\d+)')

    var data :Array = []
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var match :RegExMatch = regex.search(line)
        data.append({
            r1 = Vector2i(int(match.get_string(1)), int(match.get_string(2))),
            r2 = Vector2i(int(match.get_string(3)), int(match.get_string(4))),
        })

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pair in data_:
        # read as x 'contains other'
        var left = pair.r1.x <= pair.r2.x and pair.r2.y <= pair.r1.y
        var right = pair.r2.x <= pair.r1.x and pair.r1.y <= pair.r2.y
        if left or right: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pair in data_:
        # read as x 'contains other y'
        var left_left = pair.r1.x <= pair.r2.x and pair.r2.x <= pair.r1.y
        var left_right = pair.r1.x <= pair.r2.y and pair.r2.y <= pair.r1.y
        var right_left = pair.r2.x <= pair.r1.x and pair.r1.x <= pair.r2.y
        var right_right = pair.r2.x <= pair.r1.y and pair.r1.y <= pair.r2.y
        if left_left or left_right or right_left or right_right: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


