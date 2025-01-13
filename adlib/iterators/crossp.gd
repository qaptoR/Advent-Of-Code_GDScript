class_name CrossP
extends RefCounted


var cross_product :Array
var index


func _init( name_a :String, set_a :Array, name_b :String, set_b :Array ) -> void:
    index = 0
    cross_product = []
    for a in set_a:
        for b in set_b:
            cross_product.append({name_a: a, name_b: b})

func _iter_init(_arg) -> bool:
    index = 0

    return index < cross_product.size()


func _iter_next(_arg) -> bool:
    index += 1

    return index < cross_product.size()


func _iter_get(_arg) -> Dictionary:

    return cross_product[index]

