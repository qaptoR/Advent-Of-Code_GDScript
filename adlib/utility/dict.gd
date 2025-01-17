class_name Dict


static func from_array (arr :Array, default :Variant = null) -> Dictionary:
    var dict :Dictionary = {}
    for item in arr:
        dict[item] = default

    return dict


# static func append (to :Dictionary, from :Dictionary) -> void:
#     for key in from.keys():
#         if to.has(key):
#             if to[key] is Array:
#                 if from[key] is Array:
#                     to[key] += from[key]
#                 else:
#                     to[key].append(from[key])
#             else:
#                 if from[key] is Array:
#                     to[key] = [to[key]]
#                     to[key] += from[key]
#                 else:
#                     to[key] = [to[key], from[key]]
#             to[key].append(from[key])
#         else:
#             to[key] = from[key]
