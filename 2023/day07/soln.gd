
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2023/day07/test.txt"
    "D:/Files/advent/2023/day07/data.txt"
    # "/Users/rocco/Programming/advent/2023/day07/data.txt"
    # "/Users/rocco/Programming/advent/2023/day07/test.txt"
)

const STRENGTH1 :String = "AKQJT98765432"
const STRENGTH2 :String = "AKQT98765432J"

enum Type {
    FIVE_OAK,
    FOUR_OAK,
    FULL_HOUSE,
    THREE_OAK,
    TWO_PAIR,
    ONE_PAIR,
    HIGH_CARD,
}


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var parts :PackedStringArray = line.split(" ", false)
        data[parts[0]] = {
            bid = parts[1].to_int(),
            score = get_score(parts[0]),
        }

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var compare_scores = func(a, b) -> bool:
        if data[a].score.type1 != data[b].score.type1:
            return data[a].score.type1 > data[b].score.type1
        else: for i in data[a].score.strength1.size():
            if data[a].score.strength1[i] == data[b].score.strength1[i]: continue
            return data[a].score.strength1[i] > data[b].score.strength1[i]
        return false

    var hands :Array = data.keys()
    hands.sort_custom(compare_scores)
    for i in hands.size():
        result += data[hands[i]].bid * (i+1)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var compare_scores = func(a, b) -> bool:
        if data[a].score.type2 != data[b].score.type2:
            return data[a].score.type2 > data[b].score.type2
        else: for i in data[a].score.strength2.size():
            if data[a].score.strength2[i] == data[b].score.strength2[i]: continue
            return data[a].score.strength2[i] > data[b].score.strength2[i]
        return false

    var hands :Array = data.keys()
    hands.sort_custom(compare_scores)
    for i in hands.size():
        result += data[hands[i]].bid * (i+1)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_score(hand :String) -> Dictionary:

    var strength1 :Array = []
    var strength2 :Array = []
    var cards :Dictionary = {}
    for card in hand:
        cards[card] = cards.get(card, 0) + 1
        strength1.append(STRENGTH1.find(card))
        strength2.append(STRENGTH2.find(card))

    var type1 :Type
    var type2 :Type
    match cards.size():
        1: type1 = Type.FIVE_OAK
        2: type1 = Type.FOUR_OAK if cards.values().has(4) else Type.FULL_HOUSE
        3: type1 = Type.THREE_OAK if cards.values().has(3) else Type.TWO_PAIR
        4: type1 = Type.ONE_PAIR
        5: type1 = Type.HIGH_CARD

    match type1:
        Type.FIVE_OAK: type2 = Type.FIVE_OAK
        Type.FOUR_OAK: type2 = Type.FIVE_OAK if cards.has('J') else Type.FOUR_OAK
        Type.FULL_HOUSE: type2 = Type.FIVE_OAK if cards.has('J') else Type.FULL_HOUSE
        Type.THREE_OAK: type2 = Type.FOUR_OAK if cards.has('J') else Type.THREE_OAK
        Type.TWO_PAIR: 
            if not cards.has('J'): type2 = Type.TWO_PAIR
            elif cards['J'] == 1: type2 = Type.FULL_HOUSE
            else: type2 = Type.FOUR_OAK
        Type.ONE_PAIR:
            if not cards.has('J'): type2 = Type.ONE_PAIR
            else: type2 = Type.THREE_OAK
        Type.HIGH_CARD: type2 = Type.ONE_PAIR if cards.has('J') else Type.HIGH_CARD

    return {
        strength1 = strength1,
        strength2 = strength2,
        cards = cards,
        type1 = type1,
        type2 = type2,
    }
