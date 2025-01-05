
extends SceneTree

# Part 1 - 118
# Part 2 - 260

const DATA_FILE = (
    # "D:/Files/advent/2016/day07/test07.txt"
    "D:/Files/advent/2016/day07/data07.txt"
)


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.split("\n", false)

    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regexa = RegEx.new()
    var regexb = RegEx.new()
    regexa.compile(r"((\w)(\w)\3\2)")
    regexb.compile(r"(\[\w*(\w)(\w)\3\2\w*\])")



    for line in data_.size():
        var matchb = regexb.search_all(data_[line])
        var starts :Array = []
        var flag = false
        for match in matchb:
            starts.append(match.get_start(1))
            if match.get_string(2) == match.get_string(3): continue
            flag = true
        if flag: continue

        var matcha = regexa.search_all(data_[line])
        for match in matcha:
            if match.get_start(1) in starts: continue
            if match.get_string(2) != match.get_string(3): flag = true
        if flag: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regexa = RegEx.new()
    regexa.compile(r"(?=((\w)(\w)\2))")

    for line in data_.size():
        var sections = Array(data_[line].replace('[', ']').split(']', false))
        var inner = ' '.join(PackedStringArray(sections.slice(1, sections.size(), 2)))
        var outer = ' '.join(PackedStringArray(sections.slice(0, sections.size(), 2)))

        var matchesi = regexa.search_all(inner)
        var matcheso = regexa.search_all(outer)
        var flag = false
        for matchi in matchesi:
            if matchi.get_string(2) == matchi.get_string(3): continue
            for matcho in matcheso:
                if matcho.get_string(2) != matchi.get_string(3): continue
                if matcho.get_string(3) != matchi.get_string(2): continue
                flag = true
                break
            if flag: break
        if flag: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


