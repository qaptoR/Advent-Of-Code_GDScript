
extends SceneTree

# data solutions:
# Part 1 - 18843
# Part 2 - ?


const DATA_FILE = (
    # "D:/Files/advent/2016/day02/test02.txt"
    "D:/Files/advent/2016/day02/data02.txt"
)


var dirs :Dictionary = {
    'U': Vector2i( 0,  1),
    'D': Vector2i( 0, -1),
    'L': Vector2i(-1,  0),
    'R': Vector2i( 1,  0)
}

var buttons_1 :Dictionary = {
    [-1,  1]: '1', [0,  1]: '2', [1,  1]: '3',
    [-1,  0]: '4', [0,  0]: '5', [1,  0]: '6',
    [-1, -1]: '7', [0, -1]: '8', [1, -1]: '9',
}

var buttons_2 :Dictionary = {
                                 [0,  2]: '1',
                  [-1,  1]: '2', [0,  1]: '3', [1,  1]: '4',
    [-2, 0]: '5', [-1,  0]: '6', [0,  0]: '7', [1,  0]: '8', [2, 0]: '9',
                  [-1, -1]: 'A', [0, -1]: 'B', [1, -1]: 'C',
                                 [0, -2]: 'D'
}


func _init() -> void:
    print("Saluton, Tago 02!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.split("\n", false)
    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''
    var pos :Vector2i = Vector2i(0, 0)
    for key in buttons_1.keys():
        buttons_1[Vector2i(key[0], key[1])] = buttons_1[key]
        buttons_1.erase(key)

    for line in data_:
        for c in line:
            var new_pos :Vector2i = pos + dirs[c]
            if buttons_1.has(new_pos):
                pos = new_pos
        result += buttons_1[pos]

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''
    var pos :Vector2i = Vector2i(-2, 0)
    for key in buttons_2.keys():
        buttons_2[Vector2i(key[0], key[1])] = buttons_2[key]
        buttons_2.erase(key)

    for line in data_:
        for c in line:
            var new_pos :Vector2i = pos + dirs[c]
            if buttons_2.has(new_pos):
                pos = new_pos
        result += buttons_2[pos]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


