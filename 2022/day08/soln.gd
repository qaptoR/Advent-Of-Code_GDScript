
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day08/test1.txt"
    "D:/Files/advent/2022/day08/data.txt"
    # "/Users/rocco/Programming/advent/2022/day08/data.txt"
    # "/Users/rocco/Programming/advent/2022/day08/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 08!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))
    # for y in data.size.y:
    #     for x in data.size.x:
    #         printraw(data[Vector2i(x, y)])
    #     print()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    data['size'] = Vector2i(lines[0].length(), lines.size())

    for line in lines.size():
        var trees :PackedStringArray = lines[line].split("", false)
        for tree in trees.size():
            data[Vector2i(tree, line)] = trees[tree]

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for y in data.size.y:
        for x in data.size.x:
            if (0 != x and x != data.size.x - 1 and 0 != y and y != data.size.y - 1):
                if scan(data, Vector2i(x, y)): result += 1
                continue
            result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var scores :Dictionary = {}
    for y in data.size.y:
        for x in data.size.x:
            var pos :Vector2i = Vector2i(x, y)
            scores[pos] = score(data, pos)

    result = scores.values().max()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func scan(data :Dictionary, pos :Vector2i) -> bool:
    var visible :bool

    for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
        visible = true
        var i :int = 1
        while true:
            var new_pos :Vector2i = pos + dir *i
            if not data.has(new_pos): break
            visible = visible and (data[new_pos] < data[pos])
            i += 1
        if visible: break

    return visible


func score(data :Dictionary, pos :Vector2i) -> int:

    var tree_score :int = 1
    for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
        var i :int = 1
        var dir_score :int = 0
        while true:
            var new_pos :Vector2i = pos + dir *i
            if not data.has(new_pos): break
            dir_score += 1
            if data[new_pos] >= data[pos]: break
            i += 1
        tree_score *= dir_score

    return tree_score
