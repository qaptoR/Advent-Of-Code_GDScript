
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2017/day07/test.txt"
    "D:/Files/advent/2017/day07/data.txt"
    # "/Users/rocco/Programming/advent/2017/day07/data.txt"
    # "/Users/rocco/Programming/advent/2017/day07/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    var root :String = test_data1(data)
    test_data2(data, root)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var recursex = RegEx.new()
    recursex.compile(r"([a-z]+) \((\d+)\)(?: -> ((?:[a-z],? ?)+))?")

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var match :RegExMatch = recursex.search(line)
        data[match.get_string(1)] = {
            'weight': match.get_string(2).to_int(),
            'children': match.get_string(3).split(", ", false)
        }

    return data


func test_data1(data :Dictionary) -> String:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var nodes :Dictionary = {}
    for node in data:
        for child in data[node].children:
            nodes[child] = true

    for node in data:
        if not nodes.has(node):
            result = node
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)

    return result


func test_data2(data :Dictionary, root :String) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = rec_weigh(data, root)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func rec_weigh(data :Dictionary, node :String) -> Dictionary:
    var weight :int = data[node].weight
    var change :int = 0
    var weights :Dictionary = {}

    for child in data[node].children:
        var rcw = rec_weigh(data, child)
        change = max(change, rcw.change)
        weight += rcw.weight
        weights[rcw.weight] = weights.get(rcw.weight, []) + [child]

    var balanced = weights.size() <= 1

    if not balanced:
        prints('unbalanced: ', node, weights)
        var odd_weight = weights.keys().reduce(func(acc, key):
            return key if weights[key].size() < weights[acc].size() else acc
        )
        var normal_weight = weights.keys().reduce(func(acc, key):
            return key if weights[key].size() > weights[acc].size() else acc
        )
        var values = get_change(data, weights[odd_weight][0], normal_weight)
        change = values.change
        weight -= values.original - values.change

    var outcome = {
        weight = weight,
        change = change,
    }

    return outcome


func get_change(data :Dictionary, node :String, target :int) -> Dictionary:

    var weight :int = data[node].weight
    var cweight :int = 0
    for child in data[node].children:
        cweight += rec_weigh(data, child).weight

    var diff :int = target - (cweight + weight)

    return {
        change = weight + diff,
        original = weight,
    }

    

