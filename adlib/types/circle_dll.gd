class_name CircleDLL


var cursor :Link
var size :int


class Link extends Object:

    var data :Variant
    var next :Link
    var prev :Link

    func _init ():
        self.data = null
        self.next = null
        self.prev = null


func get_values() -> Array:
    if size == 0: return []

    var values = []
    var curr = cursor
    while true:
        values.push_back(curr.data)
        curr = curr.next

        if curr == cursor: break

    return values


func insert_right(object: Variant) -> void:
    _insert(object, 'prev', 'next')


func insert_left(object: Variant) -> void:
    _insert(object, 'next', 'prev')


func _insert(object: Variant, cursor_ :String, neighbor_ :String) -> void:
    var new_node = Link.new()
    new_node.data = object

    if size == 0:
        new_node.next = new_node
        new_node.prev = new_node
        cursor = new_node
    else:
        new_node.set(cursor_, cursor)
        new_node.set(neighbor_, cursor.get(neighbor_))
        cursor.set(neighbor_, new_node)
        new_node.get(neighbor_).set(cursor_, new_node)
        cursor = new_node

    size += 1


func remove_rotate_left() -> Variant:
    return _remove('next')


func remove_rotate_right() -> Variant:
    return _remove('prev')


func _remove(neighbor_ :String) -> Variant:
    if size == 0: return null

    var data = cursor.data

    if size == 1: cursor.free()
    else:
        var neighbor = cursor.get(neighbor_)
        cursor.prev.next = cursor.next
        cursor.next.prev = cursor.prev
        cursor.free()
        cursor = neighbor

    size -= 1
    return data


func rotate(n :int) -> void:
    if size == 0: return

    for i in range(abs(n)):
        # positive n rotates left, clockwise
        if n > 0: cursor = cursor.next

        # negative n rotates right, counter-clockwise
        else: cursor = cursor.prev


func free_mem() -> void:
    if size == 0: return

    var curr = cursor
    for i in range(size):
        var next = curr.next
        curr.free()
        curr = next

