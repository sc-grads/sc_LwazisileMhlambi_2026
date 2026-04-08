# Inheritance

class Animal:
    def __init__(self, name: str) -> None:
        self.name = name

    def drink(self) -> None:
        print(f"{self.name} is drinking.")

    def eat(self) -> None:
        print(f"{self.name} is eating.")


class Dog(Animal):  # Uses Animal as parent class
    def __init__(self, name: str) -> None:
        super().__init__(name)  # Refers to parent class

    def bark(self) -> None:
        print(f"{self.name} bark bark!")

    def routine(self) -> None:
        self.eat()
        self.bark()
        self.drink()


class Cat(Animal):  # Uses Animal as parent class
    def __init__(self, name: str) -> None:
        super().__init__(name)  # Refers to parent class

    def meow(self) -> None:
        print(f"{self.name} meow meow!")


def main() -> None:
    dog: Dog = Dog("Boomerang")
    cat: Cat = Cat("Snowball")

    dog.bark()
    cat.meow()

    dog.eat()
    cat.eat()


if __name__ == "__main__":
    main()

#super()

from typing import override

class Shape:
    def __init__(self, name: str, sides: int) -> None:
        self.name = name
        self.sides = sides

    def describe(self) -> str:
        print(f"{self.name} ({self.sides} sides)")

    def shape_method(self) -> None:
        print(f"{self.name}: shape_method()")

class Square(Shape):
    def __init__(self, size: float):
        super().__init__("Square", 4)
        self.size = size

    @override
    def describe(self) -> None:
        print(f" I am {self.name} with a size of {self.size}")

class Rectangle(Shape):
    def __init__(self, length: float, height: float):
        super().__init__("Rectangle", 4)
        self.length = length
        self.height = height

    @override
    def describe(self) -> None:
        print(f"{self.name} ({self.length}x{self.height})")

def main() -> None:
    square: Square =Square(20)
    square.describe()
    square.shape_method()

    rectangle: Rectangle = Rectangle(15, 10)
    rectangle.describe()
    rectangle.shape_method()


if __name__ == "__main__":
    main()

#Static Method

class Calculator:
    def __init__(self, version: int) -> None:
        self.version = version

    @staticmethod
    def add(*numbers: float) -> float:
        return sum(numbers)

    def get_version(self) -> int:
        return self.version

def main() -> None:
    calc: Calculator = Calculator(version=1)
    result: float = calc.add(1, 2, 3, 4)
    print(result)


if __name__ == "__main__":
    main()

#Class Method

from typing import Self

class Car:
    LIMITER: int = 200
    def __init__(self, brand: str, max_speed: int) -> None:
        self.brand = brand
        self.max_speed = max_speed

    @classmethod
    def change_limit(cls, new_limit: int) -> None:
        cls.LIMITER = new_limit

    @classmethod
    def autogenerate_max_speed(cls, brand: str) -> Self:
        lowered: str = brand.lower()
        max_speed: int = 200

        if lowered == "toyota":
            max_speed = 270
        elif lowered == "bmw":
            max_speed = 290
        elif lowered == "volvo":
            max_speed = 300

        return cls(brand, max_speed)

    def display_info(self) -> None:
        print(f"{self.brand} (max={self.max_speed}, limiter={self.LIMITER})")

def main() -> None:
    volvo: Car = Car.autogenerate_max_speed("volvo")
    volvo.display_info()

if __name__ == "__main__":
    main()

