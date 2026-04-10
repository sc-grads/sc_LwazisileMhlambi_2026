#Mypy
#Checks for compatibility of elements
items: list[str] = ["cup", "apple", "True", "[1, 2, 3]"]

#Walrus Operator
#Reduces the lines of code needed
def description(numbers: list[int]) -> dict:

    details: dict = {'length': (n_length := len(numbers)),
                     'sum': (n_sum := sum(numbers)),
                     'mean': (n_sum / n_length)}

    return details

def main() -> None:
    numbers: list[int] = [1, 10, 5, 200, -4, 7]
    print(description(numbers))
if __name__ == '__main__':
    main()

#Lambda
#One time use function
from typing import Callable

def use_all(f: Callable, values: list[int]) -> None:
    for value in values:
        f(value)

use_all(lambda v: print(f"{v * "X"}"), [2,4,10])

names: list[str] = ["Bob", "Alice", "Carol", "Dan"]
sorted_names: list[str] = sorted(names)
print(sorted_names)


#Generators
from typing import Generator

def huge_data() -> Generator:
    for i in range(1, 100_000_000_000):
        yield i


def main() -> None:
    data: Generator = huge_data()
    for i in range(200):
        print(next(data))

if __name__ == "__main__":
    main()

#Match-Case
#Used for pattern matching
status: int = 200

match status:
    case 200:
        print("Connected")
    case 403:
        print('Forbidden')
    case 404:
        print('Not Found')
    case _:
        print('Unknown')

user_input: str = input("Enter a command: ")
command: list[str] = user_input.split()

match command:
    case "find", *images:
        print(f"Finding {images}...")
    case "enlarge", image, amount:
        print(f"You enlarged {image} by {amount}x")

#Decorators
import time
from typing import Callable
from functools import wraps

def get_time(func: Callable) -> Callable:
    """Times how long the function takes to run"""

    @wraps(func)
    def wrapper(*args, **kwargs) -> None:
        start_time: float = time.perf_counter()
        func(*args, **kwargs)
        end_time: float = time.perf_counter()

        print(f"Time: {end_time - start_time: .3f}s")

    return wrapper

@get_time
def calculate() -> None:
    """Calculate() docstring"""

    print("Calculating time...")
    for i in range(20_000_000):
        pass

    print("Done")

def main() -> None:
    calculate()

if __name__ == "__main__":
    main()

#Decorators (Continued)

from typing import Callable, Any
from functools import wraps

def repeat(number: int) -> Callable:
    """Repeat a function call x amount of times"""

    def decorator(func: Callable) -> Callable:

        @wraps(func)
        def wrapper(*args: Any, **kwargs: Any) -> Any:
            value: Any = None
            for _ in range(number):
                value = func(*args, **kwargs)

            return value

        return wrapper

    return decorator

@repeat(number=3)
def greet(name: str) -> None:
    """A function used to greet people"""
    print(f"Hello {name}")


def main() -> None:
    greet("Bob")

if __name__ == "__main__":
    main()

#Enums
#Used for fixed number of options a function can accept
from enum import Enum

class State(Enum):
    OFF: int = 0
    ON: int = 1

state: State = State.OFF

if state == State.ON:
    print("The device is on")
elif state == State.OFF:
    print("The device is off")
else:
    print("Unknown state")