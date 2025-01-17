extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day05/test.txt"
    "D:/Files/advent/2023/day05/data.txt"
    # "/Users/rocco/Programming/advent/2023/day05/data.txt"
    # "/Users/rocco/Programming/advent/2023/day05/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 05!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var maps :PackedStringArray = content.split("\n\n", false)

    var regex := RegEx.new()
    regex.compile(r'\d+')
    var seeds :Array = regex.search_all(maps[0])
    for _seed in seeds: data.get_or_add('seeds', []).append(_seed.get_string(0).to_int())

    regex.compile(r'(\w+)-to-(\w+)')
    for map in range(1, maps.size()):
        var lines :PackedStringArray = maps[map].split("\n", false)
        var map_name :String = lines[0]
        var match = regex.search(map_name)
        data[match.get_string(1)] = {to = match.get_string(2), ranges = []}

        for line in range(1, lines.size()):
            var ranges :Array = lines[line].split(" ", false)
            data[match.get_string(1)].ranges.append({
                dest = ranges[0].to_int(),
                src = ranges[1].to_int(),
                len = ranges[2].to_int(),
                dr = {s = ranges[0].to_int(), e = ranges[0].to_int() + ranges[2].to_int()},
                sr = {s = ranges[1].to_int(), e = ranges[1].to_int() + ranges[2].to_int()},

            })

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var locations :Array = []

    for _seed in data.seeds:
        var current = 'seed'
        var mapped = _seed
        while current != 'location':
            mapped = data[current].ranges.reduce(func(acc, _range):
                if _range.src <= mapped and mapped < _range.src + _range.len:
                    return _range.dest + mapped - _range.src
                else: return acc
            , mapped)

            current = data[current].to
        locations.append(mapped)

    result = locations.min()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var queue :Array = []
    for r in range(0, data.seeds.size(), 2):
        queue.append({
            s = data.seeds[r],
            e = data.seeds[r] + data.seeds[r +1]
        })

    var current = 'seed'
    while current != 'location':
        var next_queue :Array = []
        while queue.size() > 0:
            var curr = queue.pop_front()
            var breakflag = false
            for r in data[current].ranges:
                var diff = r.dest - r.src
                if no_rng_overlap(curr, r.sr):
                    continue
                if curr.s < r.sr.s:
                    queue.append({ s = curr.s, e = r.sr.s, })
                    curr.s = r.sr.s
                if r.sr.e < curr.e:
                    queue.append({ s = r.sr.e, e = curr.e, })
                    curr.e = r.sr.e
                next_queue.append({ s = curr.s + diff, e = curr.e + diff, })
                breakflag = true
                break
            if not breakflag:
                next_queue.append(curr)
        queue = next_queue
        current = data[current].to

    queue.sort_custom(func(a, b): return a.s < b.s)
    result = queue[0].s


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func val_in_rng(val :int, rng :Dictionary) -> bool:
    return rng.s <= val and val <= rng.e


func rng_in_rng(in_ :Dictionary, out_ :Dictionary) -> bool:
    return out_.s <= in_.s and in_.e <= out_.e

func no_rng_overlap(a :Dictionary, b :Dictionary) -> bool:
    return a.s >= b.e or a.e <= b.s


