
extends SceneTree

# testdata solutions:
# Part 1 - 4,6,3,5,6,3,5,2,1,0
# Part 2 - 117440

# data solutions:
# Part 1 - ?
# Part 2 - ?


const DATA_FILE = (
    # "D:/Files/advent/2024/day17/test17.txt"
    # "D:/Files/advent/2024/day17/test17_2.txt"
    "D:/Files/advent/2024/day17/data17.txt"
)


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Hello, Day 17!\n")

    var data :Array = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()


    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n\n", false)
    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0

    var registers :Array[int] = []
    for row in data_[0].split("\n", false):
        registers.append(row.split(": ", false)[1].to_int())

    var p_text :String = data_[1].split(": ", false)[1]
    var program :Array[int] = []
    for p in p_text.split(",", false):
        program.append(p.to_int())

    var inst :int = 0
    var out :Array = []
    while inst < program.size():
        var jump :int = operate(program[inst], program[inst + 1], registers, out)
        inst = inst + 2 if jump == -1 else jump

    var output = out.reduce(func(acc, x): return acc + str(x) + ',', '')

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', output, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var resulte = 1
    var p_text :String = data_[1].split(": ", false)[1]
    var program :Array[int] = []
    for p in p_text.split(",", false):
        program.append(p.to_int())

    resulte = search_least_generating_value(program)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', resulte, ' time: ', time_end - time_start)


func search_least_generating_value(prog_ :Array[int]) -> int:

    var queue :Array = [{"reg_a": 0, "out_size": 0}]
    var min_val = 2 **63 -1

    var solns :Array = []
    while not queue.is_empty() and min_val == 2 ** 63 -1:
    # while not queue.is_empty():
        var state :Dictionary = queue.pop_front()
        var suffix = prog_.slice(prog_.size() - state.out_size -1, prog_.size())

        var nex_reg_a_base = state.reg_a << 3

        for i in range(8):
            var next_reg_a = nex_reg_a_base | i
            var out = generate_set(next_reg_a, prog_)
            if out == suffix:
                if prog_.size() == suffix.size():
                    min_val = min(min_val, next_reg_a)
                    solns.append(next_reg_a)
                queue.append({"reg_a": next_reg_a, "out_size": state.out_size + 1})
                queue.sort_custom(compare_states)

    return min_val


func compare_states(a :Dictionary, b :Dictionary) -> bool:
    if a.out_size == b.out_size:
        return a.reg_a < b.reg_a
    else: return a.out_size < b.out_size
    # return a.out_size < b.out_size


func generate_set(val_ :int, prog_ :Array[int]) -> Array[int]:

    var registers :Array[int] = [val_, 0, 0]
    var inst :int = 0
    var out :Array[int] = []
    while inst < prog_.size():
        var jump :int = operate(prog_[inst], prog_[inst + 1], registers, out)
        inst = inst + 2 if jump == -1 else jump

    return out


func operate(inst_ :int, op_ :int, reg_ :Array[int], out_ :Array) -> int:

    var combo :int = 0
    match op_:
        0: combo = 0
        1: combo = 1
        2: combo = 2
        3: combo = 3
        4: combo = reg_[0]
        5: combo = reg_[1]
        6: combo = reg_[2]


    var jump :int = -1
    match inst_:
        0: # adv
            var den :int = 2 ** combo
            reg_[0] = reg_[0] /den

        1: # bxl
            reg_[1] ^= op_

        2: # bst
            reg_[1] = combo & 7

        3: # jnz
            if reg_[0] != 0: jump = op_

        4: # bxc
            reg_[1] ^= reg_[2]

        5: # out
            var mod :int = combo & 7
            out_.append(mod)

        6: # bdv
            var den :int = 2 ** combo
            reg_[1] = reg_[0] /den

        7: # cdv
            var den :int = 2 ** combo
            reg_[2] = reg_[0] /den

    return jump

