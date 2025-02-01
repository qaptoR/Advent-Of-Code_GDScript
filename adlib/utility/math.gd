class_name Math


static func lcm(nums :Array) -> int:
    var primes = nums.reduce(func(acc, x): return get_primes(acc, x), {})
    var result = primes.keys().reduce(func(acc, key): return acc * pow(key, primes[key]), 1)

    return result


static func get_primes(primes :Dictionary, val :int) -> Dictionary:
    var min_factor :int = ceil(sqrt(val))
    for current in ([2, 3] + range(4, min_factor)):
        var count :int = 0
        while val % current == 0:
            val /= current
            count += 1
        if count > 0: primes[current] = max(primes.get(current, 0), count)
    if val > 1: primes[val] = max(primes.get(val, 0), 1)

    return primes
