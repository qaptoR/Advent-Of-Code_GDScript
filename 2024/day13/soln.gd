
extends SceneTree

# testdata size: 4
# testdata solutions:
# Part 1 - 480
# Part 2 - 875318608908

# data size: 320
# data solutions:
# Part 1 - 26810
# Part 2 - 108713182988244


const TEST_FILE = (
    "D:/Files/advent/2024/day13/test13.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day13/data13.txt"
)


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Hello, Day 13!\n")

    var data :Array = load_data(TEST_FILE)
    # var data :Array = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n\n", false)
    for row in rows:
        data.append(Array(row.split("\n", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var vectex := RegEx.create_from_string(r'X.(\d+), Y.(\d+)')

    var result :int = 0
    for row in data_:

        var matrix :Array = []
        for item in row:
            var match := vectex.search(item)
            matrix.append([int(match.get_string(1)), int(match.get_string(2))])

        var soln = solve_system(matrix)
        if soln.size() == 0: continue
        var flag :bool = true
        for i in range(2): if soln[i] > 100: flag = false
        if not flag: continue

        result += 3*soln[0] + soln[1]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var vectex := RegEx.create_from_string(r'X.(\d+), Y.(\d+)')
    const increase :int = 10_000_000_000_000

    var result :int = 0
    for row in data_:

        var matrix :Array = []
        for item in row:
            var match := vectex.search(item)
            matrix.append([float(match.get_string(1)), float(match.get_string(2))])
        for i in 2: matrix[2][i] += increase

        # var soln = solve_system(matrix)
        var soln = solve_matrix(matrix)
        if soln.size() == 0: continue

        result += 3*soln[0] + soln[1]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func solve_system(matrix_ :Array) -> Array:

    var matrix :Array = matrix_.duplicate(true)

    var a :int = matrix[0][0]
    var b :int = matrix[1][0]
    var c :int = matrix[2][0]

    var d :int = matrix[0][1]
    var e :int = matrix[1][1]
    var f :int = matrix[2][1]

    var denx = a*e - b*d

    var x :int = (c*e - b*f) / denx
    var y :int = (c - a*x) / b

    var soln :Array = [x, y]

    var flag :bool = true
    for i in range(2):
        var sum_p :int = 0
        for j in range(2):
            sum_p += soln[j] * matrix_[j][i]
        if sum_p != matrix_[2][i]: flag = false

    if not flag: return []

    return soln


func solve_matrix(matrix_ :Array) -> Array:

    var matrix :Array = matrix_.duplicate(true)

    # find the solution to the augmented matrix by reducing to reduced echelon form
    var x = matrix[0][0]
    for i in 3: matrix[i][0] = matrix[i][0]/x

    var y = matrix[0][1]
    for i in 3: matrix[i][1] = matrix[i][1]/y

    for i in 3: matrix[i][1] -= matrix[i][0]

    y = matrix[1][1]
    for i in 3: matrix[i][1] = matrix[i][1]/y

    var a = matrix[1][1]
    var b = matrix[1][0]
    for i in 3: matrix[i][0] -= (b/a)*matrix[i][1]

    # check if the solution is correct
    # (the solution is correct, but are the values whole numbers?)
    var soln = matrix[2].duplicate(true)
    for i in 2: soln[i] = roundi(soln[i])
    var flag :bool = true
    for i in range(2):
        var sum_p :int = 0
        for j in range(2):
            sum_p += soln[j] * roundi(matrix_[j][i])
        if sum_p != roundi(matrix_[2][i]): flag = false

    if not flag: return []

    return soln
