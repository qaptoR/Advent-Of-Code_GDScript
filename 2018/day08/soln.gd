
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2018/day08/test1.txt"
    "D:/Files/advent/2018/day08/data.txt"
    # "/Users/rocco/Programming/advent/2018/day08/data.txt"
    # "/Users/rocco/Programming/advent/2018/day08/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 08!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var tree :Dictionary = {}
    var nums := Array(content.split(" ", false))
    nums.reverse()
    var data = {
        root = rec_parse(tree, nums),
        tree = tree,
    }

    return data


func rec_parse (data :Dictionary, nums :Array) -> int:

    var num_children = int(nums.pop_back())
    var num_meta = int(nums.pop_back())

    var children :Array = []
    for i in range(num_children):
        children.append(rec_parse(data, nums))

    var id :int = data.size()

    var meta :Array = []
    for i in range(num_meta):
        meta.append(int(nums.pop_back()))

    data[id] = {'children': children, 'meta': meta}

    return id


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var queue :Array = [data.root]
    while not queue.is_empty():
        var id = queue.pop_front()
        for child in data.tree[id].children:
            queue.append(child)
        for meta in data.tree[id].meta:
            result += meta

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var values :Dictionary = {}
    rec_valuation(data, data.root, values)
    result = values[data.root]


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func rec_valuation(data :Dictionary, id :int, values :Dictionary):

    var value = 0
    if data.tree[id].children.is_empty() :
        value = data.tree[id].meta.reduce(func(acc, x): return acc + x, 0)
        values[id] = value
        return

    for child in data.tree[id].children:
        rec_valuation(data, child, values)

    for meta in data.tree[id].meta:
        var index = meta - 1
        if 0 <= index and index < data.tree[id].children.size():
            value += values[data.tree[id].children[index]]

    values[id] = value
