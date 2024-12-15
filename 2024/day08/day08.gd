
extends SceneTree

# testdata size: 12 x 12
# testdata solutions:
# Part 1 - 14
# Part 2 - 34

# data size: 50 x 50
# data solutions: 
# Part 1 - 214
# Part 2 - 809

const TEST_FILE = (
    "D:/Files/advent/2024/day08/test08.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day08/data08.txt"
)

var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 8!")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    width = data[0].size()
    height = data.size()

    test_data1(data)

    test_data2(data)

    print('fin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        var cols :PackedStringArray = row.split("", false)
        data.append(Array(cols))
    return data


func test_data1(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    # get list of all unique characters
    var signals :Array = get_signals(data)

    # for each character, get a list of all positions it appears in the data
    var antinodes :Dictionary = {}
    for sig in signals:
        var positions :Array = get_positions(data, sig)
        for i in range(positions.size() - 1):
            for j in range(i + 1, positions.size()):
                for k in range(2): match k:
                    0: antinodes[check_antinode(positions[j] - positions[i], positions[i])] = true
                    1: antinodes[check_antinode(positions[i] - positions[j], positions[j])] = true

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', antinodes.size() -1, ' time: ', time_end - time_start)


func test_data2(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    # get list of all unique characters
    var signals :Array = get_signals(data)

    # for each character, get a list of all positions it appears in the data
    var antinodes :Dictionary = {}
    var count :int = 0
    for sig in signals:
        var positions :Array = get_positions(data, sig)
        count += positions.size()
        for i in range(positions.size() - 1):
            for j in range(i + 1, positions.size()):
                for k in range(2): match k:
                    0: check_antinode_loop(data, positions[j] - positions[i], positions[i], antinodes)
                    1: check_antinode_loop(data, positions[i] - positions[j], positions[j], antinodes)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', count + antinodes.size() -1, ' time: ', time_end - time_start)



func get_signals(data :Array) -> Array:

    var signals :Array = []
    for row in data:
        var dict :Dictionary = {}
        for chare in row.filter(func(x): return x != "."):
            dict[chare] = true
        signals.append_array(dict.keys())

    var dict :Dictionary = {}
    for chare in signals:
        dict[chare] = true
    signals = dict.keys()

    return signals


func get_positions(data :Array, sig :String) -> Array:

    var positions :Array = []
    for row in data.size():
        for col in data[row].size():
            if data[row][col] == sig: positions.append(Vector2(col, row))

    return positions


func check_antinode(direction :Vector2, position :Vector2) -> Vector2:

    var new_pos :Vector2 = position + (direction * 2)

    if new_pos.x < 0 or width <= new_pos.x: return Vector2(-1, -1)
    if new_pos.y < 0 or height <= new_pos.y: return Vector2(-1, -1)

    return new_pos


func check_antinode_loop(data :Array, direction :Vector2, position :Vector2, antinodes :Dictionary) -> void:

    var i :int = 0
    while true:
        var new_pos :Vector2 = position + (direction * i)

        if new_pos.x < 0 or width <= new_pos.x:
            antinodes[Vector2(-1, -1)] = true
            break
        if new_pos.y < 0 or height <= new_pos.y:
            antinodes[Vector2(-1, -1)] = true
            break

        if data[new_pos.y][new_pos.x] == ".": antinodes[new_pos] = true
        i += 1

