
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2019/day03/test.txt"
    "D:/Files/advent/2019/day03/data.txt"
)

var DIRS :Dictionary = {
    'U': Vector2i.DOWN,
    'R': Vector2i.RIGHT,
    'D': Vector2i.UP,
    'L': Vector2i.LEFT,
}

func _init() -> void:
    print("Saluton, Tago 03!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in range(0, rows.size(), 2):
        var pair :Array = []
        pair.append(Array(rows[row].split(",", false)))
        pair.append(Array(rows[row +1].split(",", false)))
        data.append(pair)

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pair in data_:
        var visited :Dictionary = {}
        var wire_id :int = 0
        for wire in pair:
            wire_id += 1
            var port := Vector2i(0, 0)
            for extension in wire:
                var dir :String = extension[0]
                var dist :int = extension.substr(1).to_int()

                for i in range(dist):
                    port += DIRS[dir]
                    if visited.get(port, 0) == 0:
                        visited[port] = wire_id
                    elif visited[port] == wire_id:
                        pass
                    else:
                        visited[port] += wire_id

        var intersections :Array = visited.keys().filter(
            func(k): return visited[k] == 3
        )

        var closest :Vector2i = intersections.reduce(
            func(acc, x): return x if mdist(x) < mdist(acc) else acc
        )

        print('closest: ', closest, ' mdist: ', mdist(closest))

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for pair in data_:
        var visited :Dictionary = {}
        var wire_id :int = 0
        for wire in pair:
            wire_id += 1
            var port := Vector2i(0, 0)
            var steps :int = 0
            for extension in wire:
                var dir :String = extension[0]
                var dist :int = extension.substr(1).to_int()

                for i in range(dist):
                    steps += 1
                    port += DIRS[dir]
                    if visited.get(port, {}) == {}:
                        visited[port] = {wire_id: steps}
                    elif visited[port].has(wire_id):
                        pass
                    else:
                        visited[port][wire_id] = steps

        var intersections :Array = visited.keys().filter(
            func(k): return visited[k].size() == 2
        )

        var closest :Vector2i = intersections.reduce(
            func(acc, x): return x if sumlen(visited[x]) < sumlen(visited[acc]) else acc
        )

        print('closest: ', closest, ' sumlen: ', sumlen(visited[closest]))

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func mdist (x :Vector2i) -> int:
    return abs(x.x) + abs(x.y)

func sumlen (d :Dictionary) -> int:
    return d[1] + d[2]
