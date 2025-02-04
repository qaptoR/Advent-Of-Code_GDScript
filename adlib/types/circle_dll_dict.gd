class_name CircleDLLDict


var memory :Dictionary
var freed :Array
var cursor :int
var id :int

var node :Dictionary = {
    data = null,
    next = -1,
    prev = -1,
}


func _init() -> void:
    id = -1
    cursor = -1
    freed = []
    memory = {}


func get_id() -> int:
    if freed.is_empty():
        id += 1
        return id
    else: return freed.pop_back()


func get_values() -> Array:
    if memory.is_empty(): return []

    var values = []
    var curr = cursor
    while true:
        values.push_back(memory[curr].data)
        curr = memory[curr].next

        if curr == cursor: break

    return values


func insert_right(object: Variant) -> void:
    _insert(object, 'prev', 'next')


func insert_left(object: Variant) -> void:
    _insert(object, 'next', 'prev')


func _insert(object: Variant, cursor_ :String, neighbor_ :String) -> void:
    var new_node = node.duplicate(true)
    new_node.data = object

    if memory.is_empty():
        cursor = get_id()
        new_node.next = cursor
        new_node.prev = cursor
        memory[cursor] = new_node
    else:
        var new_id = get_id()
        new_node[cursor_] = cursor
        new_node[neighbor_] = memory[cursor][neighbor_]
        memory[cursor][neighbor_] = new_id
        memory[ new_node[neighbor_] ][cursor_] = new_id
        memory[new_id] = new_node
        cursor = new_id


func remove_rotate_left() -> Variant:
    return _remove('next')


func remove_rotate_right() -> Variant:
    return _remove('prev')


func _remove(neighbor_ :String) -> Variant:
    if memory.is_empty(): return null

    if memory[cursor].next == memory[cursor].prev:
        var data = memory[cursor].data
        freed.push_back(cursor)
        memory.erase(cursor)
        cursor = -1
        return data
    else:
        var data = memory[cursor].data
        var neighbor = memory[cursor][neighbor_]
        memory[ memory[cursor].prev ].next = memory[cursor].next
        memory[ memory[cursor].next ].prev = memory[cursor].prev
        freed.push_back(cursor)
        memory.erase(cursor)
        cursor = neighbor
        return data


func rotate(n :int) -> void:
    if memory.is_empty(): return

    for i in range(abs(n)):
        # positive n rotates left, clockwise
        if n > 0: cursor = memory[cursor].next

        # negative n rotates right, counter-clockwise
        else: cursor = memory[cursor].prev
