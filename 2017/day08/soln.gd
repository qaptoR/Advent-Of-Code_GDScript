
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2017/day08/test1.txt"
    "D:/Files/advent/2017/day08/data.txt"
    # "/Users/rocco/Programming/advent/2017/day08/data.txt"
    # "/Users/rocco/Programming/advent/2017/day08/test.txt"
)

var Operators :Dictionary = {
    '<':  func (a, b): return a < b,
    '>':  func (a, b): return a > b,
    '<=': func (a, b): return a <= b,
    '>=': func (a, b): return a >= b,
    '==': func (a, b): return a == b,
    '!=': func (a, b): return a != b,
}


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

    var regex = RegEx.new()
    regex.compile("([a-z]+) (inc|dec) (-?[0-9]+) if ([a-z]+) ([<>=!]+) (-?[0-9]+)")

    var data :Dictionary = {
        'registers': {},
        'instructions': []
    }
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var rematch :RegExMatch = regex.search(line)
        data.registers[rematch.get_string(1)] = 0
        data.registers[rematch.get_string(4)] = 0

        data.instructions.append({
            'register': rematch.get_string(1),
            'operation': rematch.get_string(2),
            'value': rematch.get_string(3).to_int()
                * (1 if rematch.get_string(2) == 'inc' else -1),
            'condition': {
                'register': rematch.get_string(4),
                'operator': rematch.get_string(5),
                'value': rematch.get_string(6).to_int()
            }
        })

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var copy = data.duplicate(true)
    for instruction in copy.instructions:
        if Operators[instruction.condition.operator].call(
            copy.registers[instruction.condition.register],
            instruction.condition.value
        ): copy.registers[instruction.register] += instruction.value

    result = copy.registers.values().max()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var copy = data.duplicate(true)
    var values :Dictionary = {}
    for instruction in copy.instructions:
        if Operators[instruction.condition.operator].call(
            copy.registers[instruction.condition.register],
            instruction.condition.value
        ):
            copy.registers[instruction.register] += instruction.value
            values[copy.registers[instruction.register]] = true

    result = values.keys().max()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


