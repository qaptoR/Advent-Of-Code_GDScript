
extends SceneTree

# Part 1 - 137896
# Part 2 - 501

const DATA_FILE = (
    # "D:/Files/advent/2016/day04/test04.txt"
    "D:/Files/advent/2016/day04/data04.txt"
)


func _init() -> void:
    print("Saluton, Tago 04!\n")

    var data :Array = load_data(DATA_FILE)

    var real_rooms :Array = test_data1(data)
    test_data2(real_rooms)

    print('\nfin')


func load_data (filename :String) -> Array:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var data :Array = []
    var rows :PackedStringArray = content.split("\n", false)
    for row in rows:
        var pos1 :int = row.rfind("-")
        var pos2 :int = row.rfind("[")
        data.append([
            row.substr(0, pos1),
            row.substr(pos1 +1, pos2 -pos1 -1),
            row.substr(pos2 +1, 5)
        ])

    return data


func test_data1(data_ :Array) -> Array:
    var time_start :int = Time.get_ticks_msec()

    var real_rooms :Array = []
    var result = 0
    for row in data_:
        var letters :String = row[0].replace("-", "")
        var counts :Dictionary = {}
        for letter in letters:
            if counts.get(letter, 0) == 0:
                counts[letter] = letters.count(letter)
            else: continue

        var buckets :Dictionary = {}
        for letter in counts.keys():
            var count :int = counts[letter]
            if buckets.get(count, []) == []:
                buckets[count] = [letter]
            else: buckets[count].append(letter)

        var checksum :String = "" 
        var keys :Array = buckets.keys()
        keys.sort()
        keys.reverse()
        var index :int = 0
        while checksum.length() < 5:
            var max_len :int = 5 -checksum.length()
            var options :Array = buckets[keys[index]]
            options.sort()
            for i in options.size():
                if i >= max_len: break
                checksum += buckets[keys[index]][i]
            index += 1

        if checksum == row[2]:
            result += int(row[1])
            real_rooms.append([row[0], row[1]])

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)
    return real_rooms


func test_data2(data_ :Array) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0
    var alphabet :String = "abcdefghijklmnopqrstuvwxyz"
    for room in data_:
        var letters :String = room[0].replace("-", " ")
        var shift :int = int(room[1]) % 26
        var decrypted :String = ""
        for letter in letters:
            if letter == " ":
                decrypted += " "
                continue
            var index :int = alphabet.find(letter)
            index += shift
            decrypted += alphabet[index % alphabet.length()]
        if decrypted.matchn("*north*"): prints(decrypted, room[1])

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


