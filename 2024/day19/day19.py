
import time


TEST_FILE = "D:/Files/advent/2024/day00/test00.txt"
DATA_FILE = "D:/Files/advent/2024/day00/data00.txt"
TEST_DATA = "D:/Files/advent/data00.txt"


def main():
    print("\nHello, Day 00!\n")

    # with open(TEST_FILE, "r") as file:
    # with open(DATA_FILE, "r") as file:
    with open(TEST_DATA, "r") as file:
        data = file.readlines()

    for line in data: print(line)

    # test_data1(data)
    # test_data2(data)

    print("\nfin\n")


def test_data1(data_):
    time_start = time.perf_counter()

    result = 0

    time_end = time.perf_counter()
    print(f"part 1: {result} time: {time_end - time_start:.4f} ms")


def test_data2(data_):
    time_start = time.perf_counter()

    result = 0

    time_end = time.perf_counter()
    print(f"part 1: {result} time: {time_end - time_start:.4f} ms")


main()
