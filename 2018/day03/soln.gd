
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2018/day03/test.txt"
    "D:/Files/advent/2018/day03/data.txt"
)


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Saluton, Tago 03!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # height = data.size()
    # width = data[0].size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        var info :PackedStringArray = row.split(" @ ", false)
        var id :int = int(info[0].substr(1))
        var rect_data :PackedStringArray = info[1].split(": ", false)
        var pos :PackedStringArray = rect_data[0].split(",", false)
        var size :PackedStringArray = rect_data[1].split("x", false)
        data[id] = Rect2i(
            Vector2i(int(pos[0]), int(pos[1])),
            Vector2i(int(size[0]), int(size[1]))
        )

    return data


func test_data1(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var inches :Dictionary = {}
    for claim in data_:
        for x in range(data_[claim].position.x, data_[claim].end.x):
            for y in range(data_[claim].position.y, data_[claim].end.y):
                var inch = Vector2i(x, y)
                if inches.get(inch, 0):
                    inches[inch] += 1
                else: inches[inch] = 1

    result = inches.values().filter(func(x): return x > 1).size()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var claims :Dictionary = {}
    var keys = data_.keys()
    for i in keys.size() - 1:
        for j in range(i + 1, keys.size()):
            if data_[keys[i]].intersects(data_[keys[j]]):
                claims[keys[i]] = true
                claims[keys[j]] = true

    result = data_.keys().filter(func(x): return not claims.get(x, false))[0]


    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


