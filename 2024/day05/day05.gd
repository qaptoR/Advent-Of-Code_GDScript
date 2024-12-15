
extends SceneTree

# 1176 200

const DATA_FILE = (
    "D:/Files/advent/2024/day05/data05.txt"
)


func _init() -> void:
    print("Hello, Day 5!")

    var data :Dictionary = load_data(DATA_FILE)
    var hist :Dictionary = parse_rules(data['rules'])
    # test_data1(data['updates'], hist)
    test_data2(data['updates'], hist)


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var sets :PackedStringArray = content.split("\n\n", false)
    var keys :Array = ['rules', 'updates']
    for i in 2:
        var lines :PackedStringArray = sets[i].split("\n", false)
        data[keys[i]] = lines

    return data


func parse_rules(rules :PackedStringArray) -> Dictionary:

    var hist :Dictionary = {}
    for rule in rules:
        var parts :PackedStringArray = rule.split("|", false)
        if hist.has(parts[0]):
            hist[parts[0]].append(parts[1])
        else:
            hist[parts[0]] = [parts[1]]

    return hist


func test_data1(updates :PackedStringArray, hist :Dictionary) -> void:

    var correct :Array = []
    for update in updates:
        var pages :PackedStringArray = update.split(",", false)
        var flag = false

        # check if all pages before a page are supposed to be there
        for i in range(pages.size()-1, 0, -1):
            for j in range(i-1, -1, -1):
                if hist[pages[i]].has(pages[j]):
                    flag = true
        if flag: continue

        correct.append(pages[pages.size()/2])

    var total = correct.reduce(func(accum, x): return accum + x.to_int(), 0)

    print(total)


func test_data2(updates :PackedStringArray, hist :Dictionary) -> void:

    var incorrect :Array = []
    for update in updates:
        var pages :PackedStringArray = update.split(",", false)
        var flag = false

        # check if all pages before a page are supposed to be there
        for i in range(pages.size()-1, 0, -1):
            for j in range(i-1, -1, -1):
                if hist[pages[i]].has(pages[j]):
                    flag = true
        if not flag: continue

        incorrect.append(Array(pages))

    var correct :Array = []
    for update in incorrect:
        update.sort_custom(func(a, b): return not hist[a].has(b))
        correct.append(update[update.size()/2])

    var total = correct.reduce(func(accum, x): return accum + x.to_int(), 0)

    print(total)


