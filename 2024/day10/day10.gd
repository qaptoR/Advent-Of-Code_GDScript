
extends SceneTree

# testdata size: 8 x 8
# testdata solutions:
# Part 1 - 36
# Part 2 - ?

# data size: 58 x 58
# data solutions:
# Part 1 - ?
# Part 2 - ?


const TEST_FILE = (
    "D:/Files/advent/2024/day10/test10.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day10/data10.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 10!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    width = data[0].size()
    height = data.size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split("", false)))
    return data


func test_data1(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var trailheads :Array = get_trailheads(data)

    var count :int = 0
    for trailhead in trailheads:
        var possible_trails :Array = []
        var visited :Dictionary = {}
        possible_trails.append(trailhead)
        while possible_trails.size() > 0:
            var position :Vector2 = possible_trails.pop_back()
            if data[position.y][position.x] == '9':
                visited[position] = true
                continue
            possible_trails.append_array(get_possible_trails(data, position))
        count += visited.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', count, ' time: ', time_end - time_start)


func test_data2(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var trailheads :Array = get_trailheads(data)

    var count :int = 0
    for trailhead in trailheads:
        var possible_trails :Array = []
        possible_trails.append(trailhead)
        while possible_trails.size() > 0:
            var position :Vector2 = possible_trails.pop_back()
            if data[position.y][position.x] == '9':
                count += 1
                continue
            possible_trails.append_array(get_possible_trails(data, position))

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', count, ' time: ', time_end - time_start)


func get_trailheads(data :Array) -> Array:

    var trailheads :Array = []
    for row in data.size(): 
        var idx :int = 0
        while true:
            idx = data[row].find('0', idx)
            if idx < 0: break
            trailheads.append(Vector2(idx, row))
            idx += 1

    return trailheads


func get_possible_trails(data :Array, position :Vector2) -> Array:

    var trails :Array = []
    for dir in [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]:
        var new_pos :Vector2 = position + dir
        if new_pos.x < 0 or width <= new_pos.x : continue
        if new_pos.y < 0 or height <= new_pos.y : continue

        var a :int = data[new_pos.y][new_pos.x].to_int()
        var b :int = data[position.y][position.x].to_int()

        if a <= b: continue
        if a - b > 1: continue

        trails.append(new_pos)

    return trails
