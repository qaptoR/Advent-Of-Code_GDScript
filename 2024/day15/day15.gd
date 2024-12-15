
extends SceneTree

# ltestdata size: 10x10 & 10x70
# testdata solutions:
# Part 1 - 10092
# Part 2 - 9021

# stestdata size: 8x8 & 1x15
# testdata solutions:
# Part 1 - 2028

# data size: 50x50 & 20x1000
# data solutions:
# Part 1 - 1421727
# Part 2 - ?


const STEST_FILE = "D:/Files/advent/2024/day15/stest15.txt"
const LTEST_FILE = "D:/Files/advent/2024/day15/ltest15.txt"
const DATA_FILE = "D:/Files/advent/2024/day15/data15.txt"


var height :int = 0
var width :int = 0

const PAIRS :Dictionary = {
    '[' : Vector2i.RIGHT,
    ']' : Vector2i.LEFT,
}


func _init() -> void:
    print("Hello, Day 15!\n")

    # var data :Array = load_data(STEST_FILE)
    # var data :Array = load_data(LTEST_FILE)
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

    var objs :PackedStringArray = content.split("\n\n", false)

    return Array(objs)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0

    var map :Dictionary = get_map(data_[0])
    var ops :Array = get_ops(data_[1])

    for op in ops:
        try_op(map, op)

    var keys = map.keys().duplicate(true)
    keys.erase('@')
    for cell in keys:
        if map[cell] == 'O': result += cell.x + 100 * cell.y

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var resulte = 0
    var map :Dictionary = get_map(data_[0])
    map = widen_map(map)
    var ops :Array = get_ops(data_[1])

    for op in ops:
        try_wide_op(map, op)

    var keys = map.keys().duplicate(true)
    keys.erase('@')
    for cell in keys:
        if map[cell] == '[': resulte += cell.x + 100 * cell.y

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', resulte, ' time: ', time_end - time_start)


func get_map(data_ :String) -> Dictionary:

    var map :Dictionary = {}
    var rows :Array = data_.split("\n", false)
    for row in rows.size():
        for cell in rows[row].length():
            if rows[row][cell] == '@': map['@'] = Vector2i(cell, row)
            map[Vector2i(cell, row)] = rows[row][cell]

    return map


func get_ops(data_ :String) -> Array:

    var ops :Array = []
    var rows :Array = data_.split("\n", false)
    for row in rows.size():
        ops.append_array(Array(rows[row].split('', false)))

    return ops


func try_op(map_ :Dictionary, op_ :String) -> void:

    var pos :Vector2i = map_['@']
    var dir :Vector2i = match_dir(op_)

    if push(map_, pos, dir): map_['@'] = pos + dir


func try_wide_op(map_ :Dictionary, op_ :String) -> void:

    var pos :Vector2i = map_['@']
    var dir :Vector2i = match_dir(op_)

    match dir:
        Vector2i.RIGHT, Vector2i.LEFT:
            if push(map_, pos, dir): map_['@'] = pos + dir
        Vector2i.UP, Vector2i.DOWN:
            var swaps :Dictionary = wide_push(map_, pos, dir, {})
            if swaps.size() > 0:
                for swapping in swaps.keys():
                    swap(map_, swapping[0], swapping[1])
                map_['@'] = pos + dir


func push(map_ :Dictionary, pos_ :Vector2i, dir_ :Vector2i) -> bool:

    var next_pos :Vector2i = pos_ + dir_
    match map_[next_pos]:
        '#' : return false
        '.' : swap(map_, pos_, next_pos)
        'O', '[', ']' :
            if push(map_, next_pos, dir_):
                swap(map_, pos_, next_pos)
            else: return false

    return true


func wide_push(
    map_ :Dictionary, pos_ :Vector2i, dir_ :Vector2i, swaps_ :Dictionary
) -> Dictionary:

    var next_pos :Vector2i = pos_ + dir_

    var flag :Dictionary = {}
    match map_[next_pos]:
        '#' :
            swaps_.clear()
            return swaps_
        '.' : 
            swaps_[[pos_, next_pos]] = true
            return swaps_
        '[', ']' :
            var pair_pos :Vector2i = next_pos + PAIRS[map_[next_pos]]
            var pair_next_pos :Vector2i = pair_pos + dir_

            flag = wide_push(map_, next_pos, dir_, swaps_)
            if flag.size() > 0: swaps_[[pos_, next_pos]] = true
            else: return swaps_

            flag = wide_push(map_, pair_pos, dir_, swaps_)
            if flag.size() > 0: swaps_[[pair_pos, pair_next_pos]] = true
            else: return swaps_

    return swaps_


func match_dir(op_ :String) -> Vector2i:

    match op_:
        '>' : return Vector2i.RIGHT
        '<' : return Vector2i.LEFT
        '^' : return Vector2i.UP
        'v' : return Vector2i.DOWN
        _ : return Vector2i.ZERO


func swap(map_ :Dictionary, pos1_ :Vector2i, pos2_ :Vector2i) -> void:

    var temp :String = map_[pos1_]
    map_[pos1_] = map_[pos2_]
    map_[pos2_] = temp


func widen_map(map_ :Dictionary) -> Dictionary:

    var new_map :Dictionary = {}
    var keys = map_.keys().duplicate(true)
    keys.erase('@')
    for key in keys:
        var new_key :Vector2i = key * Vector2i(2, 1)
        var next_key :Vector2i = new_key + Vector2i(1, 0)

        match map_[key]:
            '#' :
                new_map[new_key] = '#'
                new_map[next_key] = '#'
            '.' :
                new_map[new_key] = '.'
                new_map[next_key] = '.'
            'O' :
                new_map[new_key] = '['
                new_map[next_key] = ']'
            '@' :
                new_map['@'] = new_key
                new_map[new_key] = '@'
                new_map[next_key] = '.'

    return new_map
