
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2099/day00/test.txt"
    "D:/Files/advent/2019/day05/data.txt"
    # "/Users/rocco/Programming/advent/2099/day00/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 00!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.strip_edges().split(",", false)

    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var program = []
    for i in data_: program.append(i.to_int())
    var io :Dictionary = {
        'in': [1],
        'out': []
    }

    var ptr :int = 0
    while ptr != -1:
        ptr = execute(program, ptr, io)

    result = io['out']

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var program = []
    for i in data_: program.append(i.to_int())
    var io :Dictionary = {
        'in': [5],
        'out': []
    }

    var ptr :int = 0
    while ptr != -1:
        ptr = execute(program, ptr, io)

    result = io['out']

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func execute(prog :Array, ptr :int, io :Dictionary) -> int:

    var regex = RegEx.new()
    regex.compile(r"^(\d\d?)(\d)?(\d)?(\d)?$")

    var instruction :String = str(prog[ptr]).reverse()
    var match :RegExMatch = regex.search(instruction)
    var opcode :String = match.get_string(1)
    # var modea :String = match.get_string(4)
    var modeb :String = match.get_string(3)
    var modec :String = match.get_string(2)

    match int(opcode.reverse()):
        1: # add
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            prog[prog[ptr + 3]] = mem1 + mem2
            return ptr + 4

        2: # multiply
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            prog[prog[ptr + 3]] = mem1 * mem2
            return ptr + 4

        3: # input
            var mem1 = prog[ptr + 1]
            var input = io['in'].pop_back()
            prog[mem1] = input
            return ptr + 2

        4: # output
            var mem1 = prog[ptr + 1]
            var output = mem1 if modec == '1' else prog[mem1]
            io['out'].append(output)
            return ptr + 2

        5: # jump-if-true
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            return mem2 if mem1 != 0 else ptr + 3

        6: # jump-if-false
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            return mem2 if mem1 == 0 else ptr + 3

        7: # less than
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            prog[prog[ptr + 3]] = 1 if mem1 < mem2 else 0
            return ptr + 4

        8: # equals
            var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
            var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
            prog[prog[ptr + 3]] = 1 if mem1 == mem2 else 0
            return ptr + 4

        99: # halt
            return -1

    return -1

