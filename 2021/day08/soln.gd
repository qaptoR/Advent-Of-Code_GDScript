
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day08/test1.txt"
    "D:/Files/advent/2021/day08/data.txt"
    # "/Users/rocco/Programming/advent/2021/day08/data.txt"
    # "/Users/rocco/Programming/advent/2021/day08/test.txt"
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

    var data :Dictionary = {count = 0, display = []}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var parts :PackedStringArray = line.split(" | ", false)
        var input :PackedStringArray = parts[0].split(" ", false)
        var output :PackedStringArray = parts[1].split(" ", false)
        data.display.append({input = Array(input), output = Array(output)})

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var counts :Dictionary = {
        2: 1, 4: 4, 3: 7, 7: 8,
    }

    for value in data.display:
        for num in value.output:
            if num.length() in counts:
                result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for value in data.display:
        result += get_output(value)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_output(data :Dictionary) -> int:

    var nums :Dictionary = {
        0: null,
        1: null, 2: null, 3: null,
        4: null, 5: null, 6: null,
        7: null, 8: null, 9: null,
    }

    var chars :Dictionary = {
        a = null, b = null, c = null,
        d = null, e = null, f = null, g = null,
    }

    var fives :Array = []
    var sixes :Array = []

    for num in data.input:
        match num.length():
            2: nums[1] = Array(num.split('', false))
            3: nums[7] = Array(num.split('', false))
            4: nums[4] = Array(num.split('', false))
            7: nums[8] = Array(num.split('', false))
            5: fives.append(Array(num.split('', false)))
            6: sixes.append(Array(num.split('', false)))

    # get a
    chars.a = SetOps.d(nums[7], nums[1])[0]

    # determine 3
    for five in fives:
        if SetOps.ss(nums[1], five):
            nums[3] = five
            break
    fives.erase(nums[3])

    # determine 6
    for six in sixes:
        if not SetOps.ss(nums[1], six):
            nums[6] = six
            break
    sixes.erase(nums[6])

    # get d
    var adg :Array = SetOps.i(SetOps.i(fives[0], nums[3]), fives[1])
    for six in sixes:
        var temp :Array = SetOps.d(adg, six)
        if temp.size() == 1:
            chars.d = temp[0]
            break

    # get g
    chars.g = SetOps.d(adg, [chars.d, chars.a])[0]

    # determine 0
    for six in sixes:
        if not SetOps.ss([chars.d], six):
            nums[0] = six
            break
    sixes.erase(nums[0])

    # determine 9
    nums[9] = sixes[0]

    # get e
    chars.e = SetOps.d(nums[8], nums[9])[0]

    # get b
    chars.b = SetOps.d(SetOps.d(nums[4], nums[1]), [chars.d])[0]

    # get c
    chars.c = SetOps.d(nums[8], nums[6])[0]

    # determine 2
    for five in fives:
        if SetOps.e(five, [chars.a, chars.c, chars.d, chars.e, chars.g]):
            nums[2] = five
            break
    fives.erase(nums[2])

    # determine 5
    nums[5] = fives[0]

    var numstr :String = ''
    for num in data.output:
        var temp :Array = Array(num.split('', false))
        for i in range(10):
            if SetOps.e(temp, nums[i]):
                numstr += str(i)
                break


    return int(numstr)
