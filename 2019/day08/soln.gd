
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2019/day08/test1.txt"
    "D:/Files/advent/2019/day08/data.txt"
    # "/Users/rocco/Programming/advent/2019/day08/data.txt"
    # "/Users/rocco/Programming/advent/2019/day08/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 08!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))
    # for layer in data.count:
        # for y in data.y:
            # for x in data.x: printraw(data[layer][[x, y]])
            # print()
        # print()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n\n", false)
    var layer_size :PackedStringArray = lines[0].split("x", false)
    data['x'] = layer_size[0].to_int()
    data['y'] = layer_size[1].to_int()

    var layer_count :int = lines[1].length() / (data.x * data.y)
    data['count'] = layer_count

    var pixels := Array(lines[1].split("", false))
    pixels.reverse()

    for i in range(layer_count):
        var layer :Dictionary = {}
        for y in range(data.y): for x in range(data.x):
            var pixel :String = pixels.pop_back()
            layer[[x, y]] = pixel
        data[i] = layer

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var zeroes :Dictionary = {}
    for layer in data.count:
        zeroes[layer] = data[layer].values().count('0')

    var min_layer = zeroes.keys().reduce(
        func(acc, key): return acc if zeroes[acc] < zeroes[key] else key
    )
    var ones = data[min_layer].values().count('1')
    var twos = data[min_layer].values().count('2')

    result = ones * twos

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var image :Dictionary = {}

    for y in data.y: for x in data.x:
        for layer in data.count:
            var pixel = data[layer][[x, y]]
            match pixel:
                '0': image[[x, y]] = ' '
                '1': image[[x, y]] = '#'
                '2': continue
            break

    for y in data.y:
        for x in data.x: printraw(image[[x, y]])
        print()
    print()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


