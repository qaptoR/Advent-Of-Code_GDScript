
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day02/test.txt"
    # "D:/Files/advent/2022/day02/data.txt"
    "/Users/rocco/Programming/advent/2022/day02/data.txt"
    # "/Users/rocco/Programming/advent/2022/day02/test.txt"
)

var edges :Dictionary = {
    [1, 3]: true,
    [2, 1]: true,
    [3, 2]: true,
}

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

    var data :Array = []
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var parts :PackedStringArray = line.split(" ", false)
        data.append({
            opp = parts[0],
            strat = parts[1]
        })

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for game in data_:
        var opp = get_score(game.opp)
        var strat = get_score(game.strat)
        result += strat
        if strat == opp:
            result += 3
        elif edges.get([strat, opp], false):
            result += 6
        else:
            result += 0

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for game in data_:
        var opp = get_score(game.opp, true)
        var strat = get_score(game.strat, true)
        result += strat
        match strat:
            0: result += posmod(opp -2, 3) +1
            3: result += opp
            6: result += (opp % 3) +1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_score (strat :String, part :bool = false) -> int:
    var score :int = 0
    match strat:
        'A': score = 1
        'B': score = 2
        'C': score = 3
        'X': score = 0 if part else 1
        'Y': score = 3 if part else 2
        'Z': score = 6 if part else 3
    return score
