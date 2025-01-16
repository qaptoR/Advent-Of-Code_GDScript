
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day04/test.txt"
    # "D:/Files/advent/2023/day04/data.txt"
    "/Users/rocco/Programming/advent/2023/day04/data.txt"
    # "/Users/rocco/Programming/advent/2023/day04/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 04!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var cards :PackedStringArray = content.split("\n", false)
    for card in cards:
        var parts :PackedStringArray = card.split(": ", false)
        var card_id :int = parts[0].substr(parts[0].rfind(' ')+1).to_int()
        var lists :PackedStringArray = parts[1].split(" | ", false)
        data[card_id] = {
            'winners' : Dict.from_array(lists[0].split(" ", false), true),
            'chances' : Dict.from_array(lists[1].split(" ", false), true),
        }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for card in data:
        var count = get_count(data[card].chances, data[card].winners)
        if count == 0: continue
        elif count == 1: result += 1
        else: result += 1 << (count - 1)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var copies :Dictionary = {}
    for card in data:
        var count = get_count(data[card].chances, data[card].winners)
        for m in range(1 + copies.get(card, 0)): for i in range(1, count +1):
            var next_card = card + i
            if not data.has(next_card): break
            copies[next_card] = copies.get(next_card, 0) + 1

    result = data.keys().reduce(func(acc, key):
        return acc + 1 + copies.get(key, 0), 0
    )

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_count (chances :Dictionary, winners :Dictionary) -> int:
    return winners.keys().reduce(
        func(acc, key): return acc + (1 if chances.get(key, false) else 0), 0
    )
