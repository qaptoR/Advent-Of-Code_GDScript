
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2019/day02/test.txt"
    "D:/Files/advent/2019/day02/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 02!\n")

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
    for i in data_: program.append(int(i))
    program[1] = 12
    program[2] = 2

    var counter :int = 0
    while counter != -1:
        counter = execute(program, counter)

    result = program[0]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var target = 19690720
    var program = []
    for i in data_: program.append(int(i))

    for i in 100:
        var break_flag = false
        for j in 100:
            var p_copy = program.duplicate(true)
            var counter :int = 0
            p_copy[1] = i
            p_copy[2] = j
            while counter != -1:
                counter = execute(p_copy, counter)

            if p_copy[0] == target:
                result = 100 * i + j
                break_flag = true
                break
        if break_flag: break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func execute(program :Array, counter :int) -> int:

    var instruction :int = program[counter]
    match instruction:
        1:
            var mem1 = program[program[counter + 1]]
            var mem2 = program[program[counter + 2]]
            program[program[counter + 3]] = mem1 + mem2
            return counter + 4
        2:
            var mem1 = program[program[counter + 1]]
            var mem2 = program[program[counter + 2]]
            program[program[counter + 3]] = mem1 * mem2
            return counter + 4
        19:
            return -1

    return -1
