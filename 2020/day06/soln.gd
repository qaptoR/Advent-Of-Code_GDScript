
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day06/test.txt"
    "D:/Files/advent/2020/day06/data.txt"
    # "/Users/rocco/Programming/advent/2020/day06/data.txt"
    # "/Users/rocco/Programming/advent/2020/day06/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 06!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var groups :PackedStringArray = content.split("\n\n", false)
    for group in groups.size():
        data[group] = {}
        var persons :PackedStringArray = groups[group].split("\n", false)
        for person in persons.size():
            data[group][person] = persons[person].split("", false)

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for group in data:
        var questions :Dictionary = {}
        for person in data[group]:
            for question in data[group][person]:
                questions[question] = true
        result += questions.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for group in data:
        var questions :Dictionary = {}
        for person in data[group]:
            for question in data[group][person]:
                questions[question] = questions.get(question, 0) + 1
        result += questions.keys().reduce(func(acc, key) -> int:
            return acc + (1 if questions[key] == data[group].size() else 0)
        , 0)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


