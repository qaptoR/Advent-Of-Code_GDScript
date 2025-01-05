
extends SceneTree

# data size: 130 x 130
# start position: (43, 72)
# hash-20: 16425
# len-20: 120846

const DATA_FILE = (
    "D:/Files/advent/2024/day06/data06.txt"
)


func _init() -> void:
    print("Hello, Day 6!")

    var data :Array = load_data(DATA_FILE)
    # test_data1(data)
    test_data2(data)


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(row.split("", false))

    return data


func turn_right (direction :Vector2) -> Vector2:
    var r1 = Vector2(0, -1)
    var r2 = Vector2(1, 0)
    return Vector2(direction.dot(r1), direction.dot(r2))


func test_data1(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var positions :Array = []
    for r in data.size():
        var c = data[r].find("^")
        if c != -1:
            positions.append(Vector2(c, r))
            break

    var curr_pos = positions[0]
    var direction = Vector2(0, -1)
    var width = data[0].size()
    var height = data.size()
    while true:
        var next_pos = curr_pos + direction
        if next_pos.x < 0 or width <= next_pos.x: break
        if next_pos.y < 0 or height <= next_pos.y: break

        if data[next_pos.y][next_pos.x] == "#":
            direction = turn_right(direction)
            continue

        curr_pos = next_pos
        if not curr_pos in positions: positions.append(curr_pos)


    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', positions.size(), ' time: ', time_end - time_start)


func test_data2(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var positions :Array = []
    for r in data.size():
        var c = data[r].find("^")
        if c != -1:
            positions.append(Vector2(c, r))
            break
    var curr_pos = positions[0]

    var count = 0
    for row in data.size():
        if row >= 20: break
        print("Checking: ", row)

        for col in data[row].size():
            if data[row][col] != ".": continue
            var temp_data = data.duplicate(true)
            temp_data[row][col] = "#"

            # if check_cycle_len(temp_data, curr_pos):
            # if check_cycle_hash(temp_data, curr_pos):
            if check_cycle_in(temp_data, curr_pos):
                count += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', count, ' time: ', time_end - time_start)


func check_cycle_hash(data :Array, pos :Vector2) -> bool:

    var direction = Vector2(0, -1)
    var width = data[0].size()
    var height = data.size()

    var curr_pos = pos
    var unique_hash = {[curr_pos, direction]: true}
    while true:
        var next_pos = curr_pos + direction
        if next_pos.x < 0 or width <= next_pos.x: break
        if next_pos.y < 0 or height <= next_pos.y: break

        if data[next_pos.y][next_pos.x] == "#":
            direction = turn_right(direction)
            continue

        curr_pos = next_pos
        if unique_hash.get([curr_pos, direction], false): return true
        else: unique_hash[[curr_pos, direction]] = true

    return false


func check_cycle_len(data :Array, pos :Vector2) -> bool:

    var direction = Vector2(0, -1)
    var width = data[0].size()
    var height = data.size()

    var curr_pos = pos
    var unique = [curr_pos]
    var visited = 1
    while true:
        var next_pos = curr_pos + direction
        if next_pos.x < 0 or width <= next_pos.x: break
        if next_pos.y < 0 or height <= next_pos.y: break

        if data[next_pos.y][next_pos.x] == "#":
            direction = turn_right(direction)
            continue

        curr_pos = next_pos
        visited += 1
        if not curr_pos in unique: unique.append(curr_pos)
        if visited > (2* unique.size()): return true

    return false


func check_cycle_in(data :Array, pos :Vector2) -> bool:

    var direction = Vector2(0, -1)
    var width = data[0].size()
    var height = data.size()

    var curr_pos = pos
    var unique = [[curr_pos, direction]]
    while true:
        var next_pos = curr_pos + direction
        if next_pos.x < 0 or width <= next_pos.x: break
        if next_pos.y < 0 or height <= next_pos.y: break

        if data[next_pos.y][next_pos.x] == "#":
            direction = turn_right(direction)
            continue

        curr_pos = next_pos
        if not [curr_pos, direction] in unique: unique.append([curr_pos, direction])
        else: return true

    return false

