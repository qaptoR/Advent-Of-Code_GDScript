
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2016/day08/test1.txt"
    # "D:/Files/advent/2016/day08/data.txt"
    "/Users/rocco/Programming/advent/2016/day08/data.txt"
    # "/Users/rocco/Programming/advent/2016/day08/test1.txt"
)


func _init() -> void:
    print("Saluton, Tago 08!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var sizex := RegEx.new()
    sizex.compile(r'(\d+), (\d+)')

    var data :Dictionary = {}
    var sects :PackedStringArray = content.split("\n\n", false)
    var size_m = sizex.search(sects[0])
    data['size'] = Vector2i(int(size_m.strings[1]), int(size_m.strings[2]))

    var rectx := RegEx.new()
    var rotatex := RegEx.new()
    rectx.compile(r'(rect) (\d+)x(\d+)')
    rotatex.compile(r'(rotate) (row|column) (x|y)=(\d+) by (\d+)')

    data['commands'] = []
    var lines :PackedStringArray = sects[1].split("\n", false)
    for line in lines:
        var cmd = {}
        for x in [rectx, rotatex]:
            var m = x.search(line)
            if not m: continue
            match m.strings[1]:
                'rect':
                    cmd['type'] = m.strings[1]
                    cmd['size'] = Vector2i(int(m.strings[2]), int(m.strings[3]))
                'rotate':
                    cmd['type'] = m.strings[1]
                    cmd['axis'] = m.strings[3]
                    cmd['index'] = int(m.strings[4])
                    cmd['amount'] = int(m.strings[5])

        data['commands'].append(cmd)

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var screen :Dictionary = {}
    for x in data.size.x: for y in data.size.y:
        screen[Vector2i(x, y)] = false

    for cmd in data.commands:
        match cmd.type:
            'rect':
                for x in cmd.size.x: for y in cmd.size.y:
                    screen[Vector2i(x, y)] = true
            'rotate':
                var transfer :Dictionary = {}
                var x = 1 if cmd.axis == 'x' else data.size.x
                var y = 1 if cmd.axis == 'y' else data.size.y
                for col in x: for row in y:
                    var c = cmd.index if cmd.axis == 'x' else col
                    var r = cmd.index if cmd.axis == 'y' else row
                    var index = 1 if cmd.axis == 'x' else 0
                    var target = Vector2i(c, r)
                    var source = Vector2i(c, r)
                    target[index] = (target[index] + cmd.amount) % data.size[index]
                    transfer[target] = screen[source]
                for key in transfer:
                    screen[key] = transfer[key]

    for r in data.size.y:
        for c in data.size.x:
            printraw('#' if screen[Vector2i(c, r)] else '.')
        print()
    print('---')

    result = screen.values().count(true)

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


