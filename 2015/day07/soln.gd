
extends SceneTree

# data size: 339
# data solutions:
# Part 1 - 3176
# Part 2 - 14710



const DATA_FILE = (
    "D:/Files/advent/2015/day07/day07.txt"
)


var width :int = 0
var height :int = 0

var memo :Dictionary = {}


func _init() -> void:
    print("Hello, Day 7!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

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

    var graph :Dictionary = {}
    for row in data_:
        var parts :PackedStringArray = row.split(" ", false)
        match parts.size():
            3: graph[parts[2]] = { parts[0]: true }
            4: graph[parts[3]] = { parts[0]: parts[1] }
            5: graph[parts[4]] = { parts[1]: [parts[0], parts[2]] }

    var signale = rec_circuit(graph, 'a')
    memo.clear()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', signale, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var graph :Dictionary = {}
    for row in data_:
        var parts :PackedStringArray = row.split(" ", false)
        match parts.size():
            3: graph[parts[2]] = { parts[0]: true }
            4: graph[parts[3]] = { parts[0]: parts[1] }
            5: graph[parts[4]] = { parts[1]: [parts[0], parts[2]] }

    graph['b'] = { str(rec_circuit(graph, 'a')): true }
    memo.clear()
    var signale = rec_circuit(graph, 'a')

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', signale, ' time: ', time_end - time_start)


func rec_circuit(graph :Dictionary, wire :String) -> int:

    if wire in memo: return memo[wire]

    if wire.is_valid_int():
        memo[wire] = wire.to_int()  # Memoize numeric strings directly
        return memo[wire]

    var result :int = 0 # Initialize

    for key in graph[wire].keys(): 
        match key:
            'AND':
                var x :int = rec_circuit(graph, graph[wire][key][0])
                var y :int = rec_circuit(graph, graph[wire][key][1])
                result = x & y

            'OR':
                var x :int = rec_circuit(graph, graph[wire][key][0])
                var y :int = rec_circuit(graph, graph[wire][key][1])
                result = x | y

            'LSHIFT':
                var x :int = rec_circuit(graph, graph[wire][key][0])
                var y :int = rec_circuit(graph, graph[wire][key][1])
                result = x << y

            'RSHIFT':
                var x :int = rec_circuit(graph, graph[wire][key][0])
                var y :int = rec_circuit(graph, graph[wire][key][1])
                result = x >> y

            'NOT': 
                var x :int = rec_circuit(graph, graph[wire][key])
                result = ~x

            _: # Direct signal assignment 
                var x = rec_circuit(graph, key)
                result = x


    memo[wire] = result
    return result


