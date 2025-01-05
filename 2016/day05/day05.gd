
extends SceneTree

# Part 1 - 801b56a7
# Part 2 - 424a0197


func _init() -> void:
    print("Saluton, Tago 05!\n")

    test_data1()
    test_data2()

    print('\nfin')


func test_data1() -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''
    var salt :String = 'abbhdwsy'

    var i :int = 0
    while result.length() < 8:
        var new_hash :String = (salt + str(i)).md5_text()
        if new_hash.begins_with('00000'):
            result += new_hash[5]
        i += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2() -> void:
    var time_start :int = Time.get_ticks_msec()

    var result :String = '--------'
    var salt :String = 'abbhdwsy'

    var i :int = -1
    var positions :Array = [0, 1, 2, 3, 4, 5, 6, 7]
    while result.find('-') != -1:
        i += 1
        var new_hash :String = (salt + str(i)).md5_text()
        if new_hash.begins_with('00000'):
            if not new_hash[5].is_valid_int(): continue
            var pos :int = new_hash[5].to_int()
            if pos not in positions: continue
            positions.erase(pos)
            result[pos] = new_hash[6]

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


