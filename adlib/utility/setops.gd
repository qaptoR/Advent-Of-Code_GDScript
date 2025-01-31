class_name SetOps


static func i(a :Array, b :Array) -> Array:
    var result :Array = []

    var aset :Dictionary = Dict.from_array(a)
    var bset :Dictionary = Dict.from_array(b)
    for item in aset.keys():
        if bset.has(item):
            result.append(item)

    return result


static func u(a :Array, b :Array) -> Array:
    var result :Dictionary = Dict.from_array(a + b)

    return result.keys()


static func d(a :Array, b :Array) -> Array:
    var result :Array = []

    var aset :Dictionary = Dict.from_array(a)
    var bset :Dictionary = Dict.from_array(b)
    for item in aset.keys():
        if !bset.has(item):
            result.append(item)

    return result


static func sd(a :Array, b :Array) -> Array:
    var result :Array = []

    var aset :Dictionary = Dict.from_array(a)
    var bset :Dictionary = Dict.from_array(b)
    for item in aset.keys():
        if !bset.has(item):
            result.append(item)
    for item in bset.keys():
        if !aset.has(item):
            result.append(item)

    return result


static func e(a :Array, b :Array) -> bool:
    var aset :Dictionary = Dict.from_array(a)
    var bset :Dictionary = Dict.from_array(b)

    return aset == bset


static func ss(a :Array, b :Array) -> bool:
    var aset :Dictionary = Dict.from_array(a)
    var bset :Dictionary = Dict.from_array(b)

    for item in aset.keys():
        if !bset.has(item):
            return false

    return true

