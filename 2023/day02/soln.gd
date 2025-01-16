
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day02/test.txt"
    "D:/Files/advent/2023/day02/data.txt"
    # "/Users/rocco/Programming/advent/2023/day02/data.txt"
    # "/Users/rocco/Programming/advent/2023/day02/test.txt"
)


const BAG :Dictionary = {
    red = 12,
    green = 13,
    blue = 14,
}


func _init() -> void:
    print("Saluton, Tago 02!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex :RegEx = RegEx.new()
    regex.compile(r'(\d+) (\w+)(?:, )?')

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var parts :PackedStringArray = line.split(": ", false)
        var gameid :int = parts[0].substr(parts[0].rfind(' ') +1).to_int()

        data[gameid] = {}
        var hands :PackedStringArray = parts[1].split("; ", false)
        for i in hands.size():
            var matches :Array = regex.search_all(hands[i])
            for match in matches:
                var count :int = int(match.get_string(1))
                var color :String = match.get_string(2)
                data[gameid].get_or_add(i, []).append({color = color, count = count})

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for gameid in data.keys():
        var game :Dictionary = data[gameid]
        var flag = true
        for hand in game.keys():
            for color in game[hand]:
                if color.count > BAG[color.color]:
                    flag = false
        if flag: result += gameid

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for gameid in data.keys():
        var powerset :Dictionary = {
            red = [], blue = [], green = []
        }
        var game :Dictionary = data[gameid]
        for hand in game.keys():
            for color in game[hand]:
                powerset[color.color].append(color.count)

        var power :int = 1
        for color in powerset.keys():
            power *= powerset[color].max()

        result += power

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


