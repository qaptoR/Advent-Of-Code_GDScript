class_name ChooseR
extends RefCounted

var choices
var indices
var r


func _init(choices_: Array, r_: int) -> void:
    choices = choices_
    indices = range(r_)
    r = r_


func _iter_init(_arg) -> bool:
    if r > choices.size(): return false

    indices = range(r)

    return true


func _iter_next(_arg) -> bool:
    var index = r - 1
    while index >= 0 and indices[index] == choices.size() - r + index:
        index -= 1

    if index < 0: return false

    indices[index] += 1
    for j in range(index + 1, r):
        indices[j] = indices[index] + j - index

    return true


func _iter_get(_arg) -> Array:
    var combinations = []
    for i in indices: combinations.append(choices[i])

    return combinations

