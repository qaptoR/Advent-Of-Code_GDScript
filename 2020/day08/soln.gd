
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day08/test1.txt"
    "D:/Files/advent/2020/day08/data.txt"
    # "/Users/rocco/Programming/advent/2020/day08/data.txt"
    # "/Users/rocco/Programming/advent/2020/day08/test.txt"
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

    var regex :RegEx = RegEx.new()
    regex.compile(r'(nop|acc|jmp) ([+-][0-9]+)')

    var data :Dictionary = {ops = []}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var rematch :RegExMatch = regex.search(line)
        data.ops.append({
            op = rematch.get_string(1),
            arg = int(rematch.get_string(2))
        })

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var visited :Dictionary = {}
    var ip = 0
    while true:
        if visited.has(ip): break
        visited[ip] = true
        match data.ops[ip].op:
            'nop':
                ip += 1
            'acc':
                result += data.ops[ip].arg
                ip += 1
            'jmp':
                ip += data.ops[ip].arg

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var swapped :Dictionary = {'nop': 'jmp', 'jmp': 'nop'}
    var swaps :Array = []
    for i in data.ops.size(): if swapped.has(data.ops[i].op): swaps.append(i)

    for swap in swaps:
        result = 0

        var data_copy = data.duplicate(true)
        data_copy.ops[swap].op = swapped[data_copy.ops[swap].op]
        var visited :Dictionary = {}
        var break_flag = false

        var ip = 0
        while true:
            if visited.has(ip): break
            visited[ip] = true
            match data_copy.ops[ip].op:
                'nop':
                    ip += 1
                'acc':
                    result += data_copy.ops[ip].arg
                    ip += 1
                'jmp':
                    ip += data_copy.ops[ip].arg
            if ip == data_copy.ops.size():
                break_flag = true
                break
        if break_flag: break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)
