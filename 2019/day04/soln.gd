
extends SceneTree


func _init() -> void:
    print("Saluton, Tago 01!\n")

    var data :Array = load_data('108457-562041')

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (n_range :String) -> Array:

    var data :Array = []
    var vals :PackedStringArray = n_range.split("-", false)
    for val in vals: data.append(int(val))

    return data


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var regex = RegEx.new()
    regex.compile(r'(\d)\1')

    var result = 0
    for i in range(data_[0], data_[1]):
        var str_i = str(i)
        if not regex.search(str_i): continue

        var indices = range(str_i.length())
        var dec = indices.reduce(func(acc, idx):
            return acc if acc != idx -1 or str_i.unicode_at(idx) < str_i.unicode_at(idx -1) else idx
        )
        if dec != str_i.length() -1: continue

        result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regex1 = RegEx.new()
    regex1.compile(r'(\d)\1(?!\1)')
    var regex2 = RegEx.new()
    regex2.compile(r'(\d)\1\1+')

    for i in range(data_[0], data_[1] +1):
        var str_i = str(i)
        var matches1 = regex1.search_all(str_i)
        var matches2 = regex2.search_all(str_i)
        var flag = matches1.size() > 0
        for match1 in matches1:
            flag = true
            for match2 in matches2:
                if match1.get_end() == match2.get_end(): flag = false
            if flag: break
        if not flag: continue

        var indices = range(str_i.length())
        var dec = indices.reduce(func(acc, idx):
            return acc if acc != idx -1 or str_i.unicode_at(idx) < str_i.unicode_at(idx -1) else idx
        )
        if dec != str_i.length() -1: continue

        result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


