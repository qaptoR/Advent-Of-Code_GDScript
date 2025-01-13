
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2021/day04/test.txt"
    # "D:/Files/advent/2021/day04/data.txt"
    "/Users/rocco/Programming/advent/2021/day04/data.txt"
    # "/Users/rocco/Programming/advent/2021/day04/test.txt"
)


func _init() -> void:
    print("Saluton, Tago 04!\n")

    var data :Dictionary = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n\n", false)
    data['nums'] = Array(lines[0].split(','))
    data['boards'] = {}

    for board in range(1, lines.size()):
        data['boards'][board] = {'locs': {}, 'vals': {}, 'called': {}}
        var rows :PackedStringArray = lines[board].split('\n', false)
        for row in rows.size():
            var cols :PackedStringArray = rows[row].split(' ', false)
            for col in cols.size():
                var loc :Vector2i = Vector2i(col, row)
                data['boards'][board]['vals'][cols[col]] = loc
                data['boards'][board]['called'][loc] = false
                data['boards'][board]['locs'][loc] = cols[col]

    return data


func test_data1(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var win_loc
    var win_board
    for p in CrossP.new('num', data_.nums, 'board', data_.boards.keys()):
        var loc :Vector2i = data_.boards[p.board].vals.get(p.num, Vector2i(-1, -1))
        if loc.x == -1: continue
        data_.boards[p.board].called[loc] = true
        if check_board(data_.boards[p.board].called, loc):
            win_loc = loc
            win_board = p.board
            break

    if win_board == null:
        print('no winner')
        return

    var uncalled :Array = data_.boards[win_board].called.keys().filter(
        func(x): return not data_.boards[win_board].called[x]
    )
    var uncalled_sum = uncalled.reduce(
        func(acc, x): return acc + data_.boards[win_board].locs[x].to_int(),
        0
    )

    result = uncalled_sum * data_.boards[win_board].locs[win_loc].to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var win_loc
    var win_board
    var boards = data_.boards.keys().duplicate(true)
    var finished_baords = {}

    for p in CrossP.new('num', data_.nums, 'board', data_.boards.keys()):
        if finished_baords.has(p.board): continue
        var loc :Vector2i = data_.boards[p.board].vals.get(p.num, Vector2i(-1, -1))
        if loc.x == -1: continue
        data_.boards[p.board].called[loc] = true
        if check_board(data_.boards[p.board].called, loc):
            boards.erase(p.board)
            finished_baords[p.board] = true
            win_loc = loc
            win_board = p.board
            if boards.size() == 0: break

    if win_board == null:
        print('no winner')
        return

    var uncalled :Array = data_.boards[win_board].called.keys().filter(
        func(x): return not data_.boards[win_board].called[x]
    )
    var uncalled_sum = uncalled.reduce(
        func(acc, x): return acc + data_.boards[win_board].locs[x].to_int(),
        0
    )

    result = uncalled_sum * data_.boards[win_board].locs[win_loc].to_int()

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


func check_board(board :Dictionary, loc :Vector2i) -> bool:

    var check_col = true
    for x in range(0, 5):
        var new_loc :Vector2i = Vector2i(x, loc.y)
        check_col = check_col and board[new_loc]

    var check_row = true
    for y in range(0, 5):
        var new_loc :Vector2i = Vector2i(loc.x, y)
        check_row = check_row and board[new_loc]

    return check_col or check_row
