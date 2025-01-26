
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2019/day07/test1.txt"
    # "D:/Files/advent/2019/day07/test2.txt"
    # "D:/Files/advent/2019/day07/test3.txt"
    # "D:/Files/advent/2019/day07/test4.txt"
    # "D:/Files/advent/2019/day07/test5.txt"
    "D:/Files/advent/2019/day07/data.txt"
    # "/Users/rocco/Programming/advent/2019/day07/data.txt"
    # "/Users/rocco/Programming/advent/2019/day07/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    # test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {program = []}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        data.program.append_array(Array(line.split(",", false)))

    data.program = data.program.map(func(x): return x.to_int())

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var sequences :Dictionary = {}
    for seq in PermuteR.new(range(5), 5, false):
        result = 0
        for i in range(5):
            var amp = Amplifier.new(data.program)
            amp.input.append_array([result, seq[i]])
            amp.run()
            result = amp.output[0]
        sequences[seq] = result

    result = sequences.keys().reduce(
        func(acc, key): return acc if sequences[key] < sequences[acc] else key
    )

    result = [sequences[result], result]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result
    var sequences :Dictionary = {}
    for seq in PermuteR.new(range(5, 10), 5, false):
        var amps :Array = []
        for i in range(5):
            amps.append(Amplifier.new(data.program))
        var running := Amplifier.Mode.RUNNING
        var loop_count :int = 0
        result = [0]
        while running != Amplifier.Mode.HALTED:
            var i :int = 0
            for amp in amps:
                amp.input.append_array(result)
                if loop_count == 0: amp.input.append(seq[i])
                running = amp.run()
                result = amp.output.duplicate(true)
                amp.output.clear()
                i += 1
            loop_count += 1
        sequences[seq] = result

    result = sequences.keys().reduce(
        func(acc, key): return acc if sequences[key] < sequences[acc] else key
    )

    result = [sequences[result], result]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


class Amplifier:
    var prog :Array
    var input :Array
    var output :Array
    var ptr :int
    var mode :Mode

    enum Mode { RUNNING, WAITING, HALTED }

    func _init(prog_ :Array) -> void:
        prog = prog_.duplicate(true)
        # halt_mode = mode_
        input = []
        output = []
        ptr = 0
        mode = Mode.RUNNING

    func run() -> Mode:
        mode = Mode.RUNNING
        while mode == Mode.RUNNING:
            mode = execute()

        return mode

    func execute() -> Mode:
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
                ptr += 4
                return Mode.RUNNING

            2: # multiply
                var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
                var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
                prog[prog[ptr + 3]] = mem1 * mem2
                ptr += 4
                return Mode.RUNNING

            3: # input
                var mem1 = prog[ptr + 1]
                if input.size() == 0: return Mode.WAITING
                var in_ = input.pop_back()
                prog[mem1] = in_
                ptr += 2
                return Mode.RUNNING

            4: # output
                var mem1 = prog[ptr + 1]
                var out_ = mem1 if modec == '1' else prog[mem1]
                output.append(out_)
                ptr += 2
                return Mode.RUNNING

            5: # jump-if-Mode.RUNNING
                var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
                var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
                ptr = mem2 if mem1 != 0 else ptr + 3
                return Mode.RUNNING

            6: # jump-if-false
                var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
                var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
                ptr = mem2 if mem1 == 0 else ptr + 3
                return Mode.RUNNING

            7: # less than
                var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
                var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
                prog[prog[ptr + 3]] = 1 if mem1 < mem2 else 0
                ptr += 4
                return Mode.RUNNING

            8: # equals
                var mem1 = prog[ptr + 1] if modec == '1' else prog[prog[ptr + 1]]
                var mem2 = prog[ptr + 2] if modeb == '1' else prog[prog[ptr + 2]]
                prog[prog[ptr + 3]] = 1 if mem1 == mem2 else 0
                ptr += 4
                return Mode.RUNNING

            99: # halt
                return Mode.HALTED

        return Mode.HALTED

