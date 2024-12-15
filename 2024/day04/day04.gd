
extends SceneTree

const DATA_FILE = (
    "D:/Files/advent/2024/day4/data4.txt"
)

const ORTHOGONAL = [
    Vector2(1, 0),
    Vector2(0, 1),
    Vector2(-1, 0),
    Vector2(0, -1),
]

const DIAGONAL = [
    Vector2(1, 1),
    Vector2(-1, -1),
    Vector2(1, -1),
    Vector2(-1, 1),
]

func _init() -> void:
    print("Hello, Day 4!")

    var data :Array = _load_data(DATA_FILE)
    test_data1(data)
    test_data2(data)


func _load_data (filename :String) -> Array:

    var file = FileAccess.open(filename, FileAccess.READ)
    var content = file.get_as_text(true)
    file.close()

    var data :Array = []
    var lines = content.split("\n", false)
    for line in lines:
        var parts = line.split("")
        # data.append(Array(parts))
        data.append(parts)

    return data


func test_data1(data :Array) -> void:

    var count = 0

    for i in range(data.size()):
        for j in range(data[i].size()):
            for dir in ORTHOGONAL+DIAGONAL:
                if check_direction(data, Vector2(i, j), dir):
                    count += 1

    print(count)


func test_data2(data :Array) -> void:

    var count = 0

    for i in range(data.size()):
        for j in range(data[i].size()):
            if data[i][j] == "A":
                if check_around(data, Vector2(i, j)):
                    count += 1

    print(count)


func check_around(data :Array, pos :Vector2) -> bool:

    var width = data[0].size()
    var height = data.size()

    var ulist :Array = []

    for dir in DIAGONAL:
        var new_pos = pos + dir
        if new_pos.x < 0 or new_pos.x >= width: return false
        if new_pos.y < 0 or new_pos.y >= height: return false

        ulist.append(data[new_pos.x][new_pos.y])

    if ulist.count("M") != 2: return false
    if ulist.count("S") != 2: return false
    if ulist[0] == ulist[1]: return false

    return true


func check_direction(data :Array, pos :Vector2, dir :Vector2) -> bool:

    var width = data[0].size()
    var height = data.size()

    var text = ""

    for i in 4:
        var new_pos = pos + dir * i
        if new_pos.x < 0 or new_pos.x >= width: return false
        if new_pos.y < 0 or new_pos.y >= height: return false

        text += data[new_pos.x][new_pos.y]

    return text == "XMAS"
