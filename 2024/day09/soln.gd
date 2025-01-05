
extends SceneTree

# testdata size: 19
# testdata solutions:
# Part 1 - 1928
# Part 2 - 2858

# data size: 19999
# data solutions: 
# Part 1 - 6307275788409
# Part 2 - 6327174563252


const TEST_FILE = (
    "D:/Files/advent/2024/day09/test09.txt"
)

const DATA_FILE = (
    "D:/Files/advent/2024/day09/data09.txt"
)

const TEST_DISK = "00...111...2...333.44.5555.6666.777.888899"


var width :int = 0
var height :int = 0


func _init() -> void:
    print("Hello, Day 9!\n")

    # var data :Array = load_data(TEST_FILE)
    var data :Array = load_data(DATA_FILE)
    # width = data[0].size()
    height = data.size()

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.split("", false)
    return Array(data)


func test_data1(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var disk :Array = generate_disk1(data)

    fragment_disk1(disk)
    # var disk_str = disk.reduce(func(acc, x): return acc + x, '')
    var checksum :int = 0
    for i in range(disk.size()):
        if disk[i] == '.': break
        checksum += i*disk[i].to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', checksum, ' time: ', time_end - time_start)


func test_data2(data :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var disk :Array = generate_disk2(data)

    fragment_disk2(disk)
    # var disk_str = disk.reduce(func(acc, x): return acc + x, '')
    # print(disk_str)
    var checksum :int = 0
    for i in range(disk.size()):
        if disk[i] == '.': continue
        checksum += i*disk[i].to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', checksum, ' time: ', time_end - time_start)


func generate_disk1(data :Array) -> Array:

    var i :int = 0
    var fid :int = 0
    var disk :Array = []

    for gape in data:
        var gap :int = gape.to_int()
        var chare :String = ''
        match i:
            0: chare = str(fid)
            1: chare = '.'

        for j in range(gap): disk.append(chare)
        if i == 0: fid += 1
        i = (i + 1) % 2

    return disk


func fragment_disk1(disk :Array) -> void:

    while true:
        var mem_idx :int = disk.find('.')
        var file_idx :int = -1
        for i in range(disk.size() -1, -1, -1):
            if disk[i] == '.': continue
            file_idx = i
            break

        if mem_idx > file_idx: break
        var temp :String = disk[mem_idx]
        disk[mem_idx] = disk[file_idx]
        disk[file_idx] = temp


func generate_disk2(data :Array) -> Array:

    var i :int = 0
    var fid :int = 0
    var disk :Array = []

    for gape in data:
        var gap :int = gape.to_int()
        var chare :String = ''
        match i:
            0: chare = str(fid)
            1: chare = '.'

        for j in range(gap): disk.append(chare)
        if i == 0: fid += 1
        i = (i + 1) % 2

    disk.append(str(fid))
    return disk


func fragment_disk2(disk :Array) -> void:

    var fid :String = str(disk.pop_back().to_int() - 1)
    while true:
        if fid.to_int() < 0: break

        var file_size :int = disk.count(fid)
        var mem_idx :int = left_count_mem(disk, file_size)
        if mem_idx == -1: 
            fid = str(fid.to_int() - 1)
            continue
        var file_idx :int = disk.rfind(fid)
        if mem_idx > file_idx:
            fid = str(fid.to_int() - 1)
            continue


        for i in range(file_size):
            var frag = file_idx - i
            var mem = mem_idx + i

            var temp :String = disk[frag]
            disk[frag] = disk[mem]
            disk[mem] = temp

        fid = str(fid.to_int() - 1)


func left_count_mem(disk :Array, size_ :int) -> int:

    var i :int = 0
    while true:
        var idx :int = disk.find('.', i)
        if idx == -1: break
        var flag :bool = true
        for j in range(size_):
            i = idx + j
            if i >= disk.size(): return -1
            if disk[i] == '.': continue
            flag = false
            break
        if flag: return idx

    return -1
