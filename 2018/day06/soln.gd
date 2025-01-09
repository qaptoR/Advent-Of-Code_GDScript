
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2018/day06/test.txt"
    "D:/Files/advent/2018/day06/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

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
    for row in rows:
        var vals := Array(row.split(", ", false))
        data.append(Vector2i(int(vals[0]), int(vals[1])))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var setup :Dictionary = {
        'up': { 'axis': 1, 'compa': lteq, 'compb': gt },
        'right': { 'axis': 0, 'compa': lteq, 'compb': lt },
        'down': { 'axis': 1, 'compa': gteq, 'compb': gt },
        'left': { 'axis': 0, 'compa': gteq, 'compb': lt },
    }

    var finite_points :Array = []
    for px in data_:
        var infinite = 4
        for dir in ['up', 'right', 'down', 'left']:
            for py in data_:
                if px == py: continue
                var dx = abs(px.x - py.x)
                var dy = abs(px.y - py.y)
                var checka = setup[dir]['compa'].call(
                    py[setup[dir]['axis']], px[setup[dir]['axis']]
                )
                var checkb = setup[dir]['compb'].call(dx, dy)
                if not (checka or checkb):
                    infinite -= 1
                    break
        if infinite == 0: finite_points.append(px)

    var areas :Dictionary = {}
    for px in finite_points:
        areas[px] = {}
        var visited :Dictionary = { px: true }
        for dir in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:

            var queue :Array = [px + dir]

            while queue.size() > 0:
                var p = queue.pop_front()
                visited[p] = true
                var mdx = mdist(px, p)
                var closest = true
                for py in data_:
                    if py == px: continue
                    var mdy = mdist(py, p)
                    if mdy <= mdx:
                        closest = false
                        break
                if closest:
                    areas[px][p] = true
                    var neighbours = [
                        p + Vector2i.UP, p + Vector2i.RIGHT,
                        p + Vector2i.DOWN, p + Vector2i.LEFT
                    ]
                    for n in neighbours:
                        if visited.get(n, false): continue
                        queue.append(n)
                        visited[n] = true


    var max_area = areas.keys().reduce(
        func(acc, x): return x if areas[x].size() > areas[acc].size() else acc
    )

    result = areas[max_area].size() +1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var target = 10000
    # var target = 32

    var minp = data_.min()
    var maxp = data_.max()

    var start :Vector2i
    for i in range(minp.x, maxp.x):
        var breakout = false
        for j in range(minp.y, maxp.y):
            var p = Vector2i(i, j)
            var total = 0
            for px in data_:
                total += mdist(px, p)
                if total >= target: break
            if total < target:
                start = p
                breakout = true
                break
        if breakout: break

    var visited :Dictionary = { start: true }
    var queue :Array = [start]

    while queue.size() > 0:
        var p = queue.pop_front()
        var total = 0
        for px in data_:
            total += mdist(px, p)
        if total < target:
            if total >= target: break
            result += 1
            var neighbours = [
                p + Vector2i.UP, p + Vector2i.RIGHT,
                p + Vector2i.DOWN, p + Vector2i.LEFT
            ]
            for n in neighbours:
                if visited.get(n, false): continue
                queue.append(n)
                visited[n] = true

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func mdist (a :Vector2i, b :Vector2i) -> int:
    return abs(a.x - b.x) + abs(a.y - b.y)

func gteq (a :int, b :int) -> bool:
    return a >= b

func lteq (a :int, b :int) -> bool:
    return a <= b

func gt (a :int, b :int) -> bool:
    return a > b

func lt (a :int, b :int) -> bool:
    return a < b
