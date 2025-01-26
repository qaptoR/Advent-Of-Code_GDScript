class_name PermuteR
extends RefCounted

var indices :Array
var options :Array
var r :int
var w_rep :bool
var counts :Dictionary


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
        counts = Dictionary()

    for i in range(-1, r): counts[i] = 1

    return true


func _iter_next(_arg) -> bool:
    var cascade = false

    var i = r - 1
    while 0 <= i and i < r:
        counts[indices[i]] -= 1
        indices[i] += 1
        if indices[i] < options.size():
            counts[indices[i]] += 1
            if w_rep or counts.get(indices[i], 0) == 1:
                if cascade:
                    if i == r -2: cascade = false
                    i += 1
                else: return true
        else:
            cascade = !w_rep
            indices[i] = 0 if w_rep else -1
            i -= 1

    return false


func _iter_get(_arg) -> Array:
    var combinations = []
    for i in indices: combinations.append(options[i])

    return combinations

