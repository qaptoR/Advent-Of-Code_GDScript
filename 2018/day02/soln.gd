
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2018/day02/test02.txt"
    "D:/Files/advent/2018/day02/data02.txt"
)


var height :int = 0
var width :int = 0


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

    var result = 0
    var regexa := RegEx.new()
    regexa.compile(r'(?:^|(.)(?!\1))(.)\2(?!\2)')

    var regexb := RegEx.new()
    regexb.compile(r'(?:^|(.)\1?(?!\1))(.)\2\2(?!\2)')

    var counta :int = 0
    var countb :int = 0

    for row in data_:
        var packed_row = row.split('')
        packed_row.sort()
        var sorted_row = ''.join(packed_row)
        if regexa.search(sorted_row) != null:
            counta += 1
        if regexb.search(sorted_row) != null:
            countb += 1

    result = counta * countb

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''
    var packed_data := PackedStringArray(data_)
    var data :String = ' '.join(packed_data)

    var regex := RegEx.new()
    regex.compile(r'.*?\b(\w*)\w(\w*)\b.*?\1\w\2.*')

    var match :RegExMatch = regex.search(data)
    if match: result = match.get_string(1) + match.get_string(2)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


