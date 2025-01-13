
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day05/test.txt"
    "D:/Files/advent/2020/day05/data.txt"
    # "/Users/rocco/Programming/advent/2020/day05/data.txt"
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

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split("", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for tkt in data_:
        var row = find_seat(0, 127, tkt.slice(0, 7))
        var col = find_seat(0, 7, tkt.slice(7, tkt.size()))

        var seat_id = row * 8 + col
        if seat_id > result: result = seat_id

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var seats :Dictionary = {}
    for tkt in data_:
        var row = find_seat(0, 127, tkt.slice(0, 7))
        var col = find_seat(0, 7, tkt.slice(7, tkt.size()))

        var seat_id = row * 8 + col
        seats[seat_id] = true

    for i in range(0, 128 * 8):
        if not seats.get(i, false) and seats.get(i - 1, false) and seats.get(i + 1, false):
            result = i
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func find_seat(lo :int, hi :int, code :Array) -> int:
    for c in code:
        var mid :int = (hi + lo) / 2
        match c:
            'F', 'L': hi = mid
            'B', 'R': lo = mid + 1

    return hi
