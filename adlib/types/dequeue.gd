class_name DeqDict
extends RefCounted


var memory :Dictionary
var freed :Array
var head :int
var tail :int
var id :int

var node :Dictionary = {
    data = null,
    next = -1,
    prev = -1,
}

func _init() -> void:
    id = -1
    head = -1
    tail = -1
    freed = []
    memory = {}


func get_id() -> int:
    if freed.is_empty():
        id += 1
        return id
    else: return freed.pop_back()


func get_values() -> Array:
    var values = []
    var curr = head
    while curr != -1:
        values.push_back(memory[curr].data)
        curr = memory[curr].next

    return values


func push_front (object :Variant) -> void:
    var new_id = get_id()
    var new_node = node.duplicate(true)
    new_node.data = object
    new_node.next = head
    memory[new_id] = new_node

    if head != -1: memory[head].prev = new_id
    head = new_id

    if tail == -1:
        tail = new_id


func push_back (object :Variant) -> void:
    var new_id = get_id()
    var new_node = node.duplicate(true)
    new_node.data = object
    new_node.prev = tail
    memory[new_id] = new_node

    if tail != -1: memory[tail].next = new_id
    tail = new_id

    if head == -1:
        head = new_id


func pop_front () -> Variant:
    if head == -1: return null

    var popped_node = memory[head]
    popped_node.prev = head
    var data = popped_node.data

    if head == tail:  # only 1 element
        head = -1
        tail = -1
    else:
        head = popped_node.next
        memory[head].prev = -1

    freed.push_back(popped_node.prev)
    memory.erase(popped_node.prev)
    return data


func pop_back () -> Variant:
    if tail == -1: return null

    var popped_node = memory[tail]
    popped_node.next = tail
    var data = popped_node.data

    if head == tail: # only 1 element
        head = -1
        tail = -1
    else:
        tail = popped_node.prev
        memory[tail].next = -1

    freed.push_back(popped_node.next)
    memory.erase(popped_node.next)
    return data
