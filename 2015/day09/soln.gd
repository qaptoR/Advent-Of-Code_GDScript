
extends SceneTree

# data size: ?
# data solutions:
# Part 1 - ?
# Part 2 - ?



const DATA_FILE = (
    "D:/Files/advent/2015/day09/day09.txt"
)


var width :int = 0
var height :int = 0

var array_functions = {
    "min": func(arr): return arr.min(),
    "max": func(arr): return arr.max(),
}


func _init() -> void:
    print("Hello, Day 9!\n")

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

    var result :int = 0
    var graph :Dictionary = {}
    for row in data_:
        var parts :PackedStringArray = row.split(" = ", false)
        var cities :PackedStringArray = parts[0].split(" to ", false)

        if cities[0] in graph: graph[cities[0]][cities[1]] = parts[1].to_int()
        else: graph[cities[0]] = {cities[1]: parts[1].to_int()}
        if cities[1] in graph: graph[cities[1]][cities[0]] = parts[1].to_int()
        else: graph[cities[1]] = {cities[0]: parts[1].to_int()}

    var distances :Array = []
    for city in graph.keys():
        var unvisited :Array = graph.keys().duplicate(true)
        unvisited.erase(city)
        distances.append(find_path(graph, city, unvisited, 'min'))

    result = distances.min()


    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var graph :Dictionary = {}
    for row in data_:
        var parts :PackedStringArray = row.split(" = ", false)
        var cities :PackedStringArray = parts[0].split(" to ", false)

        if cities[0] in graph: graph[cities[0]][cities[1]] = parts[1].to_int()
        else: graph[cities[0]] = {cities[1]: parts[1].to_int()}
        if cities[1] in graph: graph[cities[1]][cities[0]] = parts[1].to_int()
        else: graph[cities[1]] = {cities[0]: parts[1].to_int()}

    var distances :Array = []
    for city in graph.keys():
        var unvisited :Array = graph.keys().duplicate(true)
        unvisited.erase(city)
        distances.append(find_path(graph, city, unvisited, 'max'))

    result = distances.max()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func find_path(graph :Dictionary, start :String, unvisited :Array, fn :String) -> int:

    if unvisited.size() == 0: return 0

    var distances :Array[int] = []
    var to_visit :Array = unvisited.duplicate(true)
    for city in to_visit:
        unvisited.erase(city)
        distances.append(
            graph[start][city] + find_path(graph, city, unvisited, fn)
        )
        unvisited.append(city)

    return array_functions[fn].call(distances)
