
extends SceneTree

const DATA_FILE = (
    # "D:/Files/advent/2018/day07/test.txt"
    # "D:/Files/advent/2018/day07/data.txt"
    "/Users/rocco/Programming/advent/2018/day07/data.txt"
    # "/Users/rocco/Programming/advent/2018/day07/test.txt"
)

const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


func _init() -> void:
    print("Saluton, Tago 07!\n")

    var data :Dictionary = load_data(DATA_FILE)
    # print(JSON.stringify(data, '  ', false))

    test_data1(data)
    test_data2(data)

    print('\nfin')


func load_data (filename :String) -> Dictionary:

    var file := FileAccess.open(filename, FileAccess.READ)
    var content :String = file.get_as_text(true)
    file.close()

    var regex = RegEx.new()
    regex.compile(r'Step ([A-Z]) .* step ([A-Z])')

    var data :Dictionary = {}
    var lines :PackedStringArray = content.split("\n", false)
    for line in lines:
        var match = regex.search(line)
        var head = match.get_string(1)
        var tail = match.get_string(2)
        var heads = data.get_or_add(head, {children = [], parents = []})
        heads.children.append(tail)
        var tails = data.get_or_add(tail, {children = [], parents = []})
        tails.parents.append(head)

    return data


func test_data1(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = ''

    var revsort :Callable = func(a, b): return a > b

    var queue :Dictionary = {}
    var leaves :Dictionary = {}
    for key in data: for child in data[key].children: leaves[child] = true
    for key in data: if not leaves.has(key): queue[key] = true

    var trav
    var visited :Dictionary = {}

    while not queue.is_empty():
        var pq = queue.keys()
        pq.sort_custom(revsort)
        while true:
            trav = pq.pop_back()
            var parents = data[trav].parents
            var flag = true
            for parent in parents: flag = flag and visited.has(parent)
            if flag: break
        queue.erase(trav)
        visited[trav] = true
        result += trav
        for child in data[trav].children:
            if not visited.has(child): queue[child] = true

    var time_end :int = Time.get_ticks_msec()
    print('part 1: ', result, ' time: ', time_end - time_start)


func test_data2(data :Dictionary) -> void:
    var time_start :int = Time.get_ticks_msec()

    var result = 0

    var revsort :Callable = func(a, b): return a > b

    var queue :Dictionary = {}
    var leaves :Dictionary = {}
    for key in data: for child in data[key].children: leaves[child] = true
    for key in data: if not leaves.has(key): queue[key] = true

    var visited :Dictionary = {}
    var workers :Array = []
    var busy :Array = []
    for i in range(5): workers.append({task = '', time = 0})
    # for i in range(2): workers.append({task = '', time = 0})

    var string = ''
    while not busy.is_empty() or not queue.is_empty():
        var unready :Dictionary = {}
        while true:
            if workers.is_empty(): break
            if queue.is_empty(): break
            var pq = queue.keys()
            for key in unready: pq.erase(key)
            if pq.is_empty(): break
            pq.sort_custom(revsort)
            var worker_ = workers.pop_back()
            while true:
                worker_.task = pq.pop_back()
                if worker_.task == null: break
                var parents = data[worker_.task].parents
                var flag = true
                for parent in parents: flag = flag and visited.has(parent)
                if flag: break
                else: unready[worker_.task] = true
            if worker_.task != null:
                worker_.time = ALPHABET.find(worker_.task) + 61
                # worker_.time = ALPHABET.find(worker_.task) + 1
                queue.erase(worker_.task)
                busy.append(worker_)
            else: workers.append(worker_)

        var remove :Array = []
        var completed :Array = []
        for worker in busy:
            worker.time -= 1
            if worker.time == 0:
                visited[worker.task] = true
                completed.append(worker.task)
                for child in data[worker.task].children:
                    if not visited.has(child): queue[child] = true
                remove.append(worker)

        completed.sort()
        for task in completed:
            string += task

        for worker in remove:
            busy.erase(worker)
            workers.append(worker)
        result += 1

    print(string)

    var time_end :int = Time.get_ticks_msec()
    print('part 2: ', result, ' time: ', time_end - time_start)


