
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day07/test1.txt"
    # "D:/Files/advent/2020/day07/test2.txt"
    "D:/Files/advent/2020/day07/data.txt"
    # "/Users/rocco/Programming/advent/2020/day07/data.txt"
    # "/Users/rocco/Programming/advent/2020/day07/test.txt"
)


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

    var parentex := RegEx.new()
    var childex := RegEx.new()
    parentex.compile(r'(.*) bags')
    childex.compile(r'(\d+) (.*) bags?')
    var template :Dictionary = {
        children = {},
        parents = {},
    }
    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var parts :PackedStringArray = line.split(" contain ", false)
        var parent := parentex.search(parts[0]).get_string(1)

        var children :PackedStringArray = parts[1].split(", ", false)
        for child in children:
            var match := childex.search(child)
            if not match: continue
            var count := match.get_string(1).to_int()
            var name := match.get_string(2)
            data.get_or_add(parent, template.duplicate(true)).children[name] = count
            data.get_or_add(name, template.duplicate(true)).parents[parent] = true

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var current :String = 'shiny gold'

    var queue :Array = [current]
    var visited :Dictionary = {}

    while not queue.is_empty():
        current = queue.pop_front()
        for parent in data[current].parents.keys():
            if not visited.has(parent):
                queue.append(parent)
                visited[parent] = true
                result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var current :String = 'shiny gold'

    var queue :Array = [current]

    result = rec_count(data, current)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func rec_count(data :Dictionary, current :String) -> int:
    var result = 0
    for child in data[current].children.keys():
        var count = data[current].children[child]
        result += count + count * rec_count(data, child)

    return result

