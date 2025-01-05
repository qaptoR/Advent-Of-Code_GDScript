
extends SceneTree

# testdata solutions:
# Part 1 - ?
# Part 2 - ?

# data solutions:
# Part 1 - ?
# Part 2 - ?



const DATA_FILE = (
    # "D:/Files/advent/2024/day20/test20.txt"
    "D:/Files/advent/2024/day20/data20.txt"
)


var height :int = 0
var width :int = 0

var DIRECTIONS :Array = [
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
    Vector2i.UP,
]


func _init() -> void:
    print("Hello, Day 20!\n")

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

    var rows :PackedStringArray = content.split("\n", false)

    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var map :Dictionary = {}
    var start :Vector2i
    var end :Vector2i
    for row in data_.size():
        var cols :PackedStringArray = data_[row].split("", false)
        for col in cols.size():
            if cols[col] == 'S': start = Vector2i(col, row)
            if cols[col] == 'E': end = Vector2i(col, row)
            map[Vector2i(col, row)] = cols[col]

    var distances :Dictionary = {}

    var current :Vector2i = start
    var path_len :int = 0
    while current != end:
        distances[current] = path_len
        path_len += 1
        for dir in DIRECTIONS:
            var next :Vector2i = current + dir
            if next in distances: continue
            if map.has(next) and map[next] != '#':
                current = next
                break
    distances[current] = path_len

    var cheats :Dictionary = {}
    var positions :Array = distances.keys()
    # var positions.sort_custom(func(a, b) -> bool: return distances[a] < distances[b])
    for pos in positions:
        for dir in DIRECTIONS:
            var wall :Vector2i = pos + dir
            if map.has(wall) and map[wall] == '#':
                var space :Vector2i = wall + dir
                if map.has(space) and map[space] != '#':
                    if distances[space] < distances[pos]: continue
                    cheats[[pos, space]] = (
                        distances[space] - distances[pos] - 2
                    )

    var histogram :Dictionary = {}
    for cheat in cheats:
        histogram[cheats[cheat]] = histogram.get(cheats[cheat], 0) + 1

    for hist in histogram:
        if hist >= 100: result += histogram[hist]
        # printt(hist, histogram[hist])


    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


