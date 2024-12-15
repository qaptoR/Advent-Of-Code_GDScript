
extends SceneTree

# testdata size: 9
# testdata solutions:
# Part 1 - 3749
# Part 2 - 11387

# data size: 850
# data solutions: 
# Part 1 - 4555081946288
# Part 2 - 227921760109726

const TEST_FILE = (
    "D:/Files/advent/2024/day07/test07.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day07/data07.txt"
)


func _init() -> void:
    print("Hello, Day 7!")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    test_data(data, 2, "Part 1 ")
    test_data(data, 3, "Part 2 ")


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n", false)
    return Array(rows)


func test_data(data :Array, index_ :int, str_ :String) -> void:

    var accum :int = 0
    for row in data:
        var equation :PackedStringArray = row.split(": ", false)
        var roote :int = equation[0].to_int()
        var leaves := Array(equation[1].split(" ", false))

        var soln :int = leaves[0].to_int()
        var remaining :Array = leaves.slice(1, leaves.size(), 1, true)
        if check_recursive(index_, roote, soln, remaining):
            accum += roote

    print(str_, accum)



func check_recursive(index_ :int, root_ :int, soln_ :int, leaves :Array) -> bool:

    if leaves.size() == 0:
        return root_ == soln_

    var leaf :int = leaves[0].to_int()
    var remaining :Array = leaves.slice(1, leaves.size(), 1, true)
    for i in index_: match i:
        0:
            var soln = soln_ + leaf
            if check_recursive(index_, root_, soln, remaining):
                return true
        1:
            var soln = soln_ * leaf
            if check_recursive(index_, root_, soln, remaining):
                return true
        2:
            var soln = (str(soln_) + str(leaf)).to_int()
            if check_recursive(index_, root_, soln, remaining):
                return true

    return false



