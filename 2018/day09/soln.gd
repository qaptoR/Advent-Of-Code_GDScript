
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2018/day09/test1.txt"
    "D:/Files/advent/2018/day09/data.txt"
    # "/Users/rocco/Programming/advent/2018/day09/data.txt"
    # "/Users/rocco/Programming/advent/2018/day09/test1.txt"
)


func _init() -> void:
    print("Saluton, Tago 09!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex := RegEx.new()
    regex.compile("([0-9]+) players; .* ([0-9]+) points")

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines.size():
        var rematch :RegExMatch = regex.search(lines[line])
        data[line] = {
            'players': int(rematch.get_string(1)),
            'points': int(rematch.get_string(2))
        }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for game in data:
    # for game in range(1):
        var score = play_game(data[game].players, data[game].points)
        # print('game: ', game, ' score: ', score)
        result += score

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for game in data:
        var score = play_game(data[game].players, data[game].points *100)
        # print('game: ', game, ' score: ', score)
        result += score

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func play_game(players :int, points :int) -> int:

    var scores :Dictionary = {}
    for i in range(players): scores[i] = 0

    var circle := CircleDLL.new()
    circle.insert_right(0)
    for marble in range(1, points +1):
        var curr_player = posmod(marble, players)
        if posmod(marble, 23) == 0:
            circle.rotate(-7)
            scores[curr_player] += marble + circle.remove_rotate_left()
        else:
            circle.rotate(1)
            circle.insert_right(marble)

    circle.free_mem()
    return scores.values().max()
