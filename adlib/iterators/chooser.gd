class_name ChooseR
extends RefCounted

var indices :Array
var options :Array
var r :int
var w_rep :bool


func _init(options_ :Array, r_ :int, w_rep_ :bool = false) -> void:
    options = options_
    r = r_
    w_rep = w_rep_


func _iter_init(_arg) -> bool:
    if r > options.size() and !w_rep: return false

    if w_rep:
        indices = Array()
        indices.resize(r)
        indices.fill(0)
    else:
        indices = range(r)

    return true


func _iter_next(_arg) -> bool:
    var index = r - 1

    while index >= 0 and (
        indices[index] == options.size() + (-1 if w_rep else -r + index)
    ): index -= 1

    if index < 0: return false

    indices[index] += 1
    for j in range(index +1, r):
        indices[j] = indices[index] + (0 if w_rep else j + -index)

    return true


func _iter_get(_arg) -> Array:
    var combinations = []
    for i in indices: combinations.append(options[i])

    return combinations
