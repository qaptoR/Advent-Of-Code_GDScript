
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2018/day05/test.txt"
    "D:/Files/advent/2018/day05/data.txt"
)


func _init() -> void:
    print("Saluton, Tago 05!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data := Array(content.strip_edges().split("", false))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var polymer :Dictionary = {}
    var head = -1
    for i in range(data_.size() -1, -1, -1):
        polymer[i] = {"next": head, "prev": i -1, "char": data_[i]}
        head = i

    react(polymer, head)

    result = polymer.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var alphabet = "abcdefghijklmnopqrstuvwxyz"

    var counts :Dictionary = {}
    for letter in alphabet:
        var data = data_.filter(func(x): return x.to_lower() != letter)
        var polymer :Dictionary = {}
        var head = -1
        for i in range(data.size() -1, -1, -1):
            polymer[i] = {"next": head, "prev": i -1, "char": data[i]}
            head = i

        react(polymer, head)
        counts[letter] = polymer.size()

    result = counts.values().min()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func react (polymer_ :Dictionary, head_ :int) -> void:

    var head = head_
    var current = head
    while current != -1 and polymer_[current]["next"] != -1:
        var next_node = polymer_[current]["next"]
        var a = polymer_[current]["char"]
        var b = polymer_[next_node]["char"]

        if a != b and a.to_lower() == b.to_lower():
            var previous = polymer_[current]["prev"]
            var next_next = polymer_[next_node]["next"]
            polymer_.erase(current)
            polymer_.erase(next_node)
            if previous == -1:
                head = next_next
                polymer_[next_next]["prev"] = -1
                current = next_next
            elif next_next == -1:
                polymer_[previous]["next"] = -1
                current = previous
            else:
                polymer_[previous]["next"] = next_next
                polymer_[next_next]["prev"] = previous
                current = previous
        else:
            current = polymer_[current]["next"]
