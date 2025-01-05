
extends SceneTree

# Part 1 - 50376
# Part 2 - 267

const DATA_FILE = (
    # "D:/Files/advent/2017/day02/test02.txt"
    # "D:/Files/advent/2017/day02/test02b.txt"
    "D:/Files/advent/2017/day02/data02.txt"
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
        data.append(Array(row.split(", ", false)))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    for row in data_:
        var heap = []
        for item in row: heap.append(int(item))
        result += heap.max() - heap.min()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    for row in data_:
        var heap = []
        for item in row: heap.append(int(item))
        for i in range(heap.size() -1):
            for j in range(i + 1, heap.size()):
                if heap[i] % heap[j] == 0:
                    result += heap[i] / heap[j]
                elif heap[j] % heap[i] == 0:
                    result += heap[j] / heap[i]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


