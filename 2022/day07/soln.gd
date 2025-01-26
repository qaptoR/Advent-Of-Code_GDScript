
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2022/day07/test.txt"
    "D:/Files/advent/2022/day07/data.txt"
    # "/Users/rocco/Programming/advent/2022/day07/data.txt"
    # "/Users/rocco/Programming/advent/2022/day07/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var cdex := RegEx.new()
    var lsex := RegEx.new()
    var filex := RegEx.new()
    var dirx := RegEx.new()
    cdex.compile(r'\$ cd ([a-z/.]+)')
    lsex.compile(r'\$ ls')
    filex.compile(r'([0-9]+) ([a-z.]+)')
    dirx.compile(r'dir ([a-z]+)')
    var opts :Array = [cdex, lsex, filex, dirx]

    var data :Dictionary = {}
    var stack :Array = []
    var template :Dictionary = {
        'dirs': [],
        'files': [],
    }

    var lines :PackedStringArray = content.split("\n", false)
    for line in lines: for opt in opts.size():
        var rematch :RegExMatch = opts[opt].search(line)
        if not rematch: continue
        var path :String = '/'.join(PackedStringArray(stack))
        match opt:
            0:
                var dir :String = rematch.strings[1]
                match rematch.strings[1]:
                    '..': stack.pop_back()
                    '/': stack = ['/']
                    _: stack.append(dir)
            1:
                data.get_or_add(path, template.duplicate(true))
            2:
                var size :int = int(rematch.strings[1])
                var name :String = rematch.strings[2]
                data[path].files.append({'name': name , 'size': size})
            3:
                var dir :String = rematch.strings[1]
                data[path].dirs.append(path + '/' + dir)

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var memo :Dictionary = {}

    for dir in data.keys():
        var size :int

        if memo.has(dir): size = memo[dir]
        else: size = rec_size(data, dir, memo)

        if size <= 100_000: result += size

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var total_mem :int = 70_000_000
    var target_mem :int = 30_000_000

    var memo :Dictionary = {}
    var size :int = rec_size(data, '/', memo)
    var unused_mem :int = total_mem - size
    var goal_mem :int = target_mem - unused_mem

    var dirs :Array = memo.values().filter(func(x): return x >= goal_mem)

    result = dirs.min()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func rec_size(data :Dictionary, dir :String, memo :Dictionary) -> int:

    var size :int = 0
    for file in data[dir].files:
        size += file.size
    for subdir in data[dir].dirs:
        size += rec_size(data, subdir, memo)

    memo[dir] = size
    return size
