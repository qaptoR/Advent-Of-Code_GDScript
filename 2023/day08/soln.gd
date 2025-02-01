
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day08/test1.txt"
    # "D:/Files/advent/2023/day08/test2.txt"
    "D:/Files/advent/2023/day08/data.txt"
    # "/Users/rocco/Programming/advent/2023/day08/data.txt"
    # "/Users/rocco/Programming/advent/2023/day08/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 08!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    # test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex = RegEx.new()
    regex.compile(r'(\w+) = \((\w+), (\w+)\)')

    var data :Dictionary = {}
    var chunks :PackedStringArray = content.split("\n\n", false)
    var directions := Array(chunks[0].split("", false))
    data['directions'] = directions

    var lines :PackedStringArray = chunks[1].split("\n", false)
    for line in lines:
        var rematch = regex.search(line)
        data[rematch.strings[1]] = {
            'L': rematch.strings[2],
            'R': rematch.strings[3],
        }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var index :int = 0
    var current :String = 'AAA'
    while current != 'ZZZ':
        var direction :String = data.directions[index]
        current = data[current][direction]
        index = (index + 1) % data.directions.size()
        result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var starts := data.keys()
    starts.erase('directions')
    starts = starts.filter(func(x): return x[-1] == 'A')
    starts = starts.map(func(x): return {
        'current': x,
        'count': 0,
    })

    var index :int = 0
    var finished :Array = []
    while true:
        result += 1
        var direction :String = data.directions[index]
        var erase :Array = []
        for start in starts:
            start.current = data[start.current][direction]
            if start.current[-1] == 'Z':
                start.count = result
                finished.append(start)
                erase.append(start)
                continue
        for e in erase: starts.erase(e)
        if starts.size() == 0: break
        index = (index + 1) % data.directions.size()

    print(finished)
    print('---')
    result = finished.reduce(func(acc, x): return get_primes(acc, x.count), {})
    result = result.keys().reduce(func(acc, key): return acc * pow(key, result[key]), 1)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_primes(primes :Dictionary, val :int) -> Dictionary:

    var min_factor :int = ceil(sqrt(val))
    for current in ([2, 3] + range(4, min_factor)):
        var count :int = 0
        while val % current == 0:
            val /= current
            count += 1
        if count > 0:
            primes[current] = max(primes.get(current, 0), count)
        current += 1
    if val > 1:
        primes[val] = max(primes.get(val, 0), 1)

    return primes
