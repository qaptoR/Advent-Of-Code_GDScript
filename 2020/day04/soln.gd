
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2020/day04/test.txt"
    "D:/Files/advent/2020/day04/data.txt"
    # "/Users/rocco/Programming/advent/2020/day04/data.txt"
)


var fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid']
var eye_colors = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']


func _init() -> void:
    print("Saluton, Tago 04!\n")

    var data :Array = load_data(DATA_FILE)

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :PackedStringArray = content.split("\n\n", false)

    return Array(data)


func test_data1(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regex = RegEx.new()
    regex.compile(r'\w\w\w:#?\w+')

    var reqd = fields.slice(0, fields.size() - 1)

    for pp in data_:
        var matches = regex.search_all(pp)
        var pp_data = {}
        for ppd in matches:
            var ppd_data = ppd.get_string().split(':')
            pp_data[ppd_data[0]] = ppd_data[1]

        var valid = true
        for r in reqd:
            if not pp_data.has(r):
                valid = false
                break

        if valid: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var regex = RegEx.new()
    regex.compile(r'\w\w\w:#?\w+')

    var hgt_reg = RegEx.new()
    hgt_reg.compile(r'^(\d+)(cm|in)$')

    var hcl_reg = RegEx.new()
    hcl_reg.compile(r'^#[0-9a-f]{6}$')

    var pid_reg = RegEx.new()
    pid_reg.compile(r'^\d{9}$')

    var reqd = fields.slice(0, fields.size() - 1)

    for pp in data_:
        var matches = regex.search_all(pp)
        var pp_data = {}
        for ppd in matches:
            var ppd_data = ppd.get_string().split(':')
            pp_data[ppd_data[0]] = ppd_data[1]

        var valid = true
        for r in reqd:
            valid = valid and pp_data.has(r)
            if not valid: break

            match r:
                'byr':
                    valid = valid and pp_data[r].length() == 4
                    valid = valid and 1920 <= pp_data[r].to_int() 
                    valid = valid and pp_data[r].to_int() <= 2002
                'iyr':
                    valid = valid and pp_data[r].length() == 4
                    valid = valid and 2010 <= pp_data[r].to_int()
                    valid = valid and pp_data[r].to_int() <= 2020
                'eyr':
                    valid = valid and pp_data[r].length() == 4
                    valid = valid and 2020 <= pp_data[r].to_int()
                    valid = valid and pp_data[r].to_int() <= 2030
                'hgt':
                    var match = hgt_reg.search(pp_data[r])
                    valid = valid and match != null
                    if not valid: break

                    var hgt = match.get_string(1)
                    var unit = match.get_string(2)
                    match unit:
                        'cm':
                            valid = valid and 150 <= hgt.to_int()
                            valid = valid and hgt.to_int() <= 193
                        'in':
                            valid = valid and 59 <= hgt.to_int()
                            valid = valid and hgt.to_int() <= 76
                'hcl':
                    valid = valid and hcl_reg.search(pp_data[r]) != null
                'ecl':
                    valid = valid and eye_colors.has(pp_data[r])
                'pid':
                    valid = valid and pid_reg.search(pp_data[r]) != null

        if valid: result += 1

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


