
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day03/test.txt"
    # "D:/Files/advent/2023/day03/data.txt"
    "/Users/rocco/Programming/advent/2023/day03/data.txt"
    # "/Users/rocco/Programming/advent/2023/day03/test.txt"
)

var directions :Array = [
    Vector2i.UP,
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
    Vector2i.UP + Vector2i.RIGHT,
    Vector2i.UP + Vector2i.LEFT,
    Vector2i.DOWN + Vector2i.RIGHT,
    Vector2i.DOWN + Vector2i.LEFT,
]


func _init() -> void:
    print("Saluton, Tago 03!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {
        lines = Array(content.split("\n", false))
    }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var numex = RegEx.new()
    var symbex = RegEx.new()
    numex.compile(r'([0-9]+)')
    symbex.compile(r'([^.0-9])')

    var nums :Array = []
    var symbs :Array = []

    for line in data.lines.size():
        var nmatches = numex.search_all(data.lines[line])
        var smatches = symbex.search_all(data.lines[line])
        for match in nmatches:
            nums.append({
                l = line, s = match.get_start(1), e = match.get_end(1) -1,
                n = match.get_string(1),
            })
        for match in smatches:
            symbs.append({
                l = line, s = match.get_start(1),
            })

    var valid :Dictionary = {}
    for symb in symbs:
        var loc = Vector2i(symb.s, symb.l)
        for num in nums:
            if valid.get(num, false): continue
            for dir in directions:
                var nloc = loc + dir
                if nloc.y != num.l: continue
                if nloc.x < num.s or num.e < nloc.x: continue
                valid[num] = true

    for num in valid: result += int(num.n)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var numex = RegEx.new()
    var symbex = RegEx.new()
    numex.compile(r'([0-9]+)')
    symbex.compile(r'([^.0-9])')

    var nums :Array = []
    var symbs :Array = []

    for line in data.lines.size():
        var nmatches = numex.search_all(data.lines[line])
        var smatches = symbex.search_all(data.lines[line])
        for match in nmatches:
            nums.append({
                l = line, s = match.get_start(1), e = match.get_end(1) -1,
                n = match.get_string(1),
            })
        for match in smatches:
            symbs.append({
                l = line, s = match.get_start(1),
                c = match.get_string(1),
            })

    var valid :Dictionary = {}
    for symb in symbs:
        if symb.c != '*': continue
        var loc = Vector2i(symb.s, symb.l)
        valid[symb] = {}
        for num in nums:
            if valid[symb].get(num, false): continue
            for dir in directions:
                var nloc = loc + dir
                if nloc.y != num.l: continue
                if nloc.x < num.s or num.e < nloc.x: continue
                valid[symb][num] = true

    for symb in valid:
        if valid[symb].size() != 2: continue
        var ratio :int = 1
        for num in valid[symb]: ratio *= int(num.n)
        result += ratio

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


