class_name Dict


static func from_array (arr :Array, default :Variant = null) -> Dictionary:
    var dict :Dictionary = {}
    for item in arr:
        dict[item] = default

    return dict
