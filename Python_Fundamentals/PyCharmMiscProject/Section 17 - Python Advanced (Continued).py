#Memoization

import time
from functools import cache

@cache
def count_vowels(text: str) -> int:
    print("Counting...")
    time.sleep(3)
    return sum(text.count(vowel) for vowel in "aeiouAEIOU")

def main() -> None:
    while True:
        user_input: str = input("You: ").lower()

        if user_input == "info":
            print(f"Bot: {count_vowels.cache_info()}")
        elif user_input == "clear":
            count = count_vowels.cache_clear()
            print(f"Bot: Cache has been cleared!")
        else:
            print(f"Bot: That text contains {count_vowels(user_input)}vowels")

if __name__ == "__main__":
    main()

#@cached property
import time
from functools import cached_property

class DataSet:
    def __init__(self, data: list[float]) -> None:
        self.data = data

    def show_data(self) -> None:
        print(self._data)

    @cached_property
    def sum(self) -> float:
        print("Calculating sum...")
        time.sleep(2)
        return sum(self._data)

    def mean(self) -> float:
        print("Calculating mean...")
        time.sleep(2)
        return sum(self.data) / len(self._data)

def main() -> None:
    ds: DataSet = DataSet([1.5, 2.5, 10, 7])
    ds.show_data()

    while True:
        user_input: str = input("You: ").lower()

        if user_input == "clear sum":
            del ds.sum
            print("Sum cached cleared!")
        elif user_input == "clear mean":
            del ds.mean
            print("Mean cached cleared!")
        elif user_input == "sum":
            print(ds.sum)
        elif user_input == "mean":
            print(ds.mean)
        else:
            print("Invalid input")

if __name__ == "__main__":
    main()

#Monkey Patching
import time
import logging

class Internet:
    def __init__(self, provider: str) -> None:
        self.provider = provider

    def connect(self) -> None:
        print(f"[{self.provider}] Connecting...")
        time.sleep(2)
        print(f"[{self.provider}] Connected")

def test_connect() -> None:
    print("[Provider] You are now connected")

def main() -> None:
    internet: Internet = Internet("Telkom")

    internet.connect = test_connect
    internet.connect()

if __name__ == "__main__":
    main()

#Timing Code

from timeit import timeit, repeat

a: str = "list(range(1000))"
b: str = "list(range(1000))"
c: str = "list(range(1000))"

a_time: float = min(repeat(stmt=a, repeat=5, number=100_000))
b_time: float = min(repeat(stmt=a, repeat=5, number=100_000))
c_time: float = min(repeat(stmt=a, repeat=5, number=100_000))

print(f"a: {a_time: .3f}s")
print(f"b: {b_time: .3f}s")
print(f"c: {c_time: .3f}s")
