
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day05/test.txt"
    # "D:/Files/advent/2022/day05/data.txt"
    "/Users/rocco/Programming/advent/2022/day05/data.txt"
    # "/Users/rocco/Programming/advent/2022/day05/test.txt"
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
    var chunks :PackedStringArray = content.split("\n\n", false)

    var regex = RegEx.new()
    regex.compile(r'(?: {3}|(?:\[(\w)\]))\s?')
    var stack_rows :PackedStringArray = chunks[0].split("\n", false)
    stack_rows.reverse()
    var stacks :Dictionary = {}
    for i in range(1, stack_rows.size()):
        var matches :Array = regex.search_all(stack_rows[i])
        for j in matches.size():
            if matches[j].get_string(1) != '':
                stacks[j+1] = stacks.get(j+1, []) + [matches[j].get_string(1)]
    data['stacks'] = stacks

    data['moves'] = []
    regex.compile(r'^.*?(\d+).*?(\d+).*?(\d+)$')
    var move_rows :PackedStringArray = chunks[1].split("\n", false)
    for row in move_rows:
        var match :RegExMatch = regex.search(row)
        data.moves.append({
            count = match.get_string(1).to_int(),
            from = match.get_string(2).to_int(),
            to = match.get_string(3).to_int(),
        })

    return data


func test_data1(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var data :Dictionary = data_.duplicate(true)

    for move in data.moves:
        for i in move.count:
            data.stacks[move.to].append(data.stacks[move.from].pop_back())

    var keys :Array = data.stacks.keys()
    keys.sort()
    result = keys.reduce(func(acc, key):
        return acc + data.stacks[key][-1] if data.stacks[key].size() > 0 else '',
        ''
    )

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var data :Dictionary = data_.duplicate(true)

    for move in data.moves:
        data.stacks[move.to] += data.stacks[move.from].slice(
            data.stacks[move.from].size() - move.count, data.stacks[move.from].size()
        )
        data.stacks[move.from].resize(data.stacks[move.from].size() - move.count)

    var keys :Array = data.stacks.keys()
    keys.sort()
    result = keys.reduce(func(acc, key):
        return acc + data.stacks[key][-1] if data.stacks[key].size() > 0 else '',
        ''
    )

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


