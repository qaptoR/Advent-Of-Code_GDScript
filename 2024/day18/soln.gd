
extends SceneTree

# testdata solutions:
# Part 1 - 22
# Part 2 - 6,1

# data solutions:
# Part 1 - 294
# Part 2 - 31,22



const DATA_FILE = (
    # "D:/Files/advent/2024/day18/test18.txt"
    "D:/Files/advent/2024/day18/data18.txt"
)


var height :int = 0
var width :int = 0


func _init() -> void:
    print("Hello, Day 18!\n")

    var data :Array = load_data(DATA_FILE)
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
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        data.append(Array(row.split(",", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var astar := AStarGrid2D.new()
    astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar.region = Rect2i(0, 0, 71, 71)
    astar.update()

    for i in range(1024):
        var region :Rect2i = Rect2i(int(data_[i][0]), int(data_[i][1]), 1, 1)
        astar.fill_solid_region(region, true)

    var path :Array = astar.get_id_path(Vector2i(0, 0), Vector2i(70, 70))

    result = path.size() -1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var astar := AStarGrid2D.new()
    astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar.region = Rect2i(0, 0, 71, 71)
    astar.update()

    for i in range(1024):
        var region :Rect2i = Rect2i(int(data_[i][0]), int(data_[i][1]), 1, 1)
        astar.fill_solid_region(region, true)

    for i in range(1024, data_.size()):
        var region :Rect2i = Rect2i(int(data_[i][0]), int(data_[i][1]), 1, 1)
        astar.fill_solid_region(region, true)
        var path :Array = astar.get_id_path(Vector2i(0, 0), Vector2i(70, 70))
        if Vector2i(70, 70) not in path:
            result = "%s,%s" %[data_[i][0], data_[i][1]]
            break

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


