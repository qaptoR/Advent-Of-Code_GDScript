
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day02/test.txt"
    "D:/Files/advent/2021/day02/data.txt"
    # "/Users/rocco/Programming/advent/2021/day02/data.txt"
)


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

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split(" ", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var pos := Vector2i.ZERO
    for command in data_: match command[0]:
        'forward': pos += Vector2i.RIGHT * int(command[1])
        'down': pos += Vector2i.DOWN * int(command[1])
        'up': pos += Vector2i.UP * int(command[1])

    result = abs(pos.x) * abs(pos.y)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var pos := Vector2i.ZERO
    var aim :int = 0

    for command in data_: match command[0]:
        'down': aim += int(command[1])
        'up': aim -= int(command[1])
        'forward':
            pos += Vector2i.RIGHT * int(command[1])
            pos += Vector2i.DOWN * aim * int(command[1])

    result = abs(pos.x) * abs(pos.y)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


