
extends SceneTree

# Part 1 - ?
# Part 2 - ?

const DATA_FILE = (
    # "D:/Files/advent/2099/day00/test.txt"
    # "D:/Files/advent/2099/day00/data.txt"
    "/Users/rocco/Programming/advent/2018/day04/data.txt"
    # "/Users/rocco/Programming/advent/2018/day04/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 00!\n")

    var data :Dictionary = load_data(DATA_FILE)

    var shifts = test_data1(data)
    test_data2(shifts)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        var info :PackedStringArray = row.split("] ", false)
        var stamps :PackedStringArray = info[0].split(" ", false)
        var date := Array(stamps[0].substr(1).split("-", false))
        var time := Array(stamps[1].split(":", false))
        if not data.has(date): data[date] = {}
        data[date][time] = info[1]

    return data


func test_data1(data_ :Dictionary) -> Dictionary:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var regexg := RegEx.new()
    regexg.compile(r"^Guard #([0-9]+)")

    var shift_count :int = 0
    var shifts :Dictionary = {}
    var guard :int = -1
    var dates :Array = data_.keys()
    dates.sort()
    for date in dates:
        var times :Array = data_[date].keys()
        times.sort()
        for time in times:
            var check_shift :RegExMatch = regexg.search(data_[date][time])
            if check_shift:
                guard = int(check_shift.get_string(1))
                if not shifts.has(guard): shifts[guard] = {}
                shift_count += 1
                continue
            if not shifts[guard].has(shift_count): shifts[guard][shift_count] = []
            shifts[guard][shift_count].append({'time': time[1], 'info': data_[date][time]})

    var counts :Dictionary = {}
    for g in shifts:
        var count :int = 0
        for shift in shifts[g]:
            for i in range(0, shifts[g][shift].size(), 2):
                var start :int = int(shifts[g][shift][i]['time'])
                var end :int = int(shifts[g][shift][i + 1]['time'])
                count += end - start
        counts[g] = count

    var max_guard = counts.keys().reduce(
        func(m, key): return key if counts[key] > counts[m] else m
    )

    var minutes :Array = []
    minutes.resize(60)
    minutes.fill(0)
    for shift in shifts[max_guard]:
        for i in range(0, shifts[max_guard][shift].size(), 2):
            var start :int = int(shifts[max_guard][shift][i]['time'])
            var end :int = int(shifts[max_guard][shift][i + 1]['time'])
            for j in range(start, end):
                minutes[j] += 1

    var max_minute = minutes.max()   
    max_minute = minutes.find(max_minute)

    # prints(max_guard, max_minute)
    result = max_guard * max_minute

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)

    return shifts


func test_data2(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var counts :Dictionary = {}
    for g in data_:
        var minutes :Array = []
        minutes.resize(60)
        minutes.fill(0)
        for shift in data_[g]:
            for i in range(0, data_[g][shift].size(), 2):
                var start :int = int(data_[g][shift][i]['time'])
                var end :int = int(data_[g][shift][i + 1]['time'])
                for j in range(start, end):
                    minutes[j] += 1
        counts[g] = minutes

    var max_guard = counts.keys().reduce(
        func(m, key): return key if counts[key].max() > counts[m].max() else m
    )

    var max_minute = counts[max_guard].max()
    max_minute = counts[max_guard].find(max_minute)

    # prints(max_guard, max_minute)
    result = max_guard * max_minute

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


