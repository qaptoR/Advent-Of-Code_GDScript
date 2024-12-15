
import time


TEST_FILE = "D:/Files/advent/2024/day01/test01.txt"
DATA_FILE = "D:/Files/advent/2024/day01/data01.txt"


def main():
    print("\nHello, Day 01!\n")

    # with open(TEST_FILE, "r") as file:
    with open(DATA_FILE, "r") as file:
        data = file.readlines()

    test_data1(data)
    test_data2(data)

    print("\nfin\n")


def test_data1(data_):
    time_start = time.perf_counter()

    result = 0

    lists = [[], []]
    for line in data_:
        nums = line.split('   ')
        lists[0].append(int(nums[0]))
        lists[1].append(int(nums[1]))

    for i in range(2):
        lists[i].sort(reverse=True)

    for i in range(len(lists[0])):
        a = lists[0].pop()
        b = lists[1].pop()
        result += abs(a - b)

    time_end = time.perf_counter()
    print(f"part 1: {result} time: {time_end - time_start:.4f}")


def test_data2(data_):
    time_start = time.perf_counter()

    result = 0

    lists = [[], []]
    for line in data_:
        nums = line.split('   ')
        lists[0].append(int(nums[0]))
        lists[1].append(int(nums[1]))

    for a in lists[0]:
        count = 0
        for b in lists[1]:
            if a == b: count += 1
        result += count * a

    time_end = time.perf_counter()
    print(f"part 2: {result} time: {time_end - time_start:.4f}")


main()
