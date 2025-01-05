
extends SceneTree

# Part 1 - 480
# Part 2 - 349975

var DIRS = [
    Vector2i(1, 0),
    Vector2i(0, 1),
    Vector2i(-1, 0),
    Vector2i(0, -1),
]

var DIAGS = [
    Vector2i(1, 1),
    Vector2i(-1, 1),
    Vector2i(-1, -1),
    Vector2i(1, -1),
]


func _init() -> void:
    print("Saluton, Tago 00!\n")

    test_data1([347991])
    test_data2([347991])

    print('\nfin')


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var current = Vector2i(0, 0)
    var dir = 0
    var edges = [0, 0, 0, 0]
    var positions :Dictionary = {1: current}
    var i = 2
    while i <= data_[0]:
        var flag :bool
        match dir:
            0, 1: flag = current[dir%2] <= edges[dir]
            2, 3: flag = -current[dir%2] <= edges[dir]
        if flag:
            current += DIRS[dir]
            positions[i] = current
            i += 1
        else:
            edges[dir] += 1
            dir = (dir + 1) % 4

    result = abs(positions[data_[0]].x) + abs(positions[data_[0]].y)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var current = Vector2i(0, 0)
    var dir = 0
    var edges = [0, 0, 0, 0]
    var positions :Dictionary = {current: 1}
    var i = 2
    while i <= data_[0]:
        var flag :bool
        match dir:
            0, 1: flag = current[dir%2] <= edges[dir]
            2, 3: flag = -current[dir%2] <= edges[dir]
        if flag:
            current += DIRS[dir]
            var sum = 0
            for neighbor in DIRS + DIAGS:
                sum += positions.get(current + neighbor, 0)
            positions[current] = sum
            if sum > data_[0]:
                result = sum
                break
            i += 1
        else:
            edges[dir] += 1
            dir = (dir + 1) % 4

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


