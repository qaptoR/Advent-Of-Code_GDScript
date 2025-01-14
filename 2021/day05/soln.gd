
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day05/test.txt"
    # "D:/Files/advent/2021/day05/data.txt"
    "/Users/rocco/Programming/advent/2021/day05/data.txt"
    # "/Users/rocco/Programming/advent/2021/day05/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 05!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex = RegEx.new()
    regex.compile(r'(\d+),(\d+) -> (\d+),(\d+)')

    var data :Array = []
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var match = regex.search(line)
        data.append({
            start = Vector2i(match.get_string(1).to_int(), match.get_string(2).to_int()),
            end = Vector2i(match.get_string(3).to_int(), match.get_string(4).to_int()),
        })

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var grid :Dictionary = {}
    for line in data_:
        if not check_ortho(line): continue
        var dx = line.end.x - line.start.x
        var dy = line.end.y - line.start.y
        var slope = Vector2i(signi(dx), signi(dy))
        var length = max(abs(dx), abs(dy))
        for i in length +1:
            var loc = line.start + slope * i
            grid[loc] = grid.get(loc, 0) + 1

    result = grid.keys().filter(func(loc): return grid[loc] > 1).size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var grid :Dictionary = {}
    for line in data_:
        if not check_valid_line(line): continue
        var dx = line.end.x - line.start.x
        var dy = line.end.y - line.start.y
        var slope = Vector2i(signi(dx), signi(dy))
        var length = max(abs(dx), abs(dy))
        for i in length +1:
            var loc = line.start + slope * i
            grid[loc] = grid.get(loc, 0) + 1

    result = grid.keys().filter(func(loc): return grid[loc] > 1).size()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func check_ortho (line :Dictionary) -> bool:
    return (line.start.x == line.end.x) or (line.start.y == line.end.y)


func check_diag (line :Dictionary) -> bool:
    return abs(line.start.x - line.end.x) == abs(line.start.y - line.end.y)


func check_valid_line (line :Dictionary) -> bool:
    return check_ortho(line) or check_diag(line)
