
extends SceneTree

# data size: 8
# data solutions:
# Part 1 - ?
# Part 2 - ?



const DATA_FILE = (
    "D:/Files/advent/2015/day11/day11.txt"
)


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 11!\n")

    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    # height = data.size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


const alphabet :String = "abcdefghijklmnopqrstuvwxyz"


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var rows :PackedStringArray = content.split("\n", false)
    return Array(rows)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = 0
    var passwd :String = get_valid_passwd(data_[0])
    print('passwd: ', passwd)

    passwd = get_valid_passwd(passwd)
    print('passwd: ', passwd)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :int = data_.size()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func get_valid_passwd(passwd :String) -> String:

    while true:
        passwd = next_passwd(passwd)
        if is_valid(passwd):
            break

    return passwd


func next_passwd(passwd :String) -> String:

    var pos :int = passwd.length() - 1
    while pos >= 0:
        var ch :String = passwd[pos]
        if ch == 'z':
            passwd[pos] = 'a'
            pos -= 1
        else:
            passwd[pos] = alphabet[alphabet.find(ch) + 1]
            break

    return passwd


func is_valid(passwd :String) -> bool:

    for ch in ['i', 'o', 'l']:
        if ch in passwd: return false

    var dupex := RegEx.create_from_string(r'(.)\1.*(.)\2')
    if not dupex.search(passwd): return false

    var seqex := RegEx.create_from_string(
        r'abc|bcd|cde|def|efg|fgh|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz'
    )
    if not seqex.search(passwd): return false

    return true
