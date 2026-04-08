#OOP - Object-Oriented Programming
#Classes and Objects
class Car:
    def __init__(self, brand: str, wheels: int) -> None:
        self.brand =brand
        self.wheels = wheels

    def turn_on(self) -> None:
        print(f"Turning on: {self.brand}")

    def turn_off(self) -> None:
        print(f"Turning off: {self.brand}")

    def drive(self, km: float) -> None:
        print(f"Driving : {self.brand} for {km}km")

    def describe(self) -> None:
        print(f"{self.brand} is a car with {self.wheels} wheels")

def main() -> None:
    bmw: Car = Car("BMW", 4)
    bmw.turn_on()
    bmw.drive(10)
    bmw.turn_off()
    bmw.describe()

    volvo: Car = Car("Volvo", 6)
    volvo.turn_on()
    volvo.drive(30)
    volvo.turn_off()
    volvo.describe()


if __name__ == "__main__":
        main()

#__init__() - block of code that is called for new object in class

class Connection:
    def __init__(self, connection_type: str, cost: float) -> None: #self - current instance of the class
        print(f"{connection_type} connection established! (Cost: ${cost}/h)")
        self.connection_type = connection_type
        self.cost = cost

    def close_connection(self) -> None:
        print(f"Closing {self.connection_type} connection...")

def main() -> None:
    internet: Connection= Connection("Internet", 2)
    satellite: Connection= Connection("Satellite", 20)

    internet.close_connection()
    satellite.close_connection()

if __name__ == "__main__":
    main()

#Self - Current instance of the class(e.g Apple, Banana)
#Self - Naming convention (it can be changed to "this")

class Fruit:
    def __init__(self, name: str, grams: float) -> None:
        self.name = name
        self.grams = grams

    def eat(self) -> None:
        print(f"Eating {self.grams}g of {self.name}")


def main() -> None:
    apple: Fruit = Fruit("Apple",25)
    print(apple.name)
    apple.eat()

    banana: Fruit = Fruit("Banana",10)
    print(banana.name)
    banana.eat()

if __name__ == "__main__":
    main()

#Attributes (Class and Instance)

class Car: #Car is a class attribute
    SPEED_LIMIT_KM: float =140 #Attribute

    def __init__(self, brand: str) -> None:
        self.brand = brand

    def drive(self, *, speed: float) -> None:
        if speed > self.SPEED_LIMIT_KM:
            print(f"Limiter activiated: Driving at {self.SPEED_LIMIT_KM} km/h")
        else:
            print(f"Driving at {speed} km/h")

def main() -> None: #Toyota and BMW are instances
    toyota: Car = Car("Toyota")
    bmw: Car = Car("BMW")

    toyota.drive(speed=200)
    bmw.drive(speed=210)

    Car.SPEED_LIMIT_KM = 99

    toyota.drive(speed=200)
    bmw.drive(speed=210)

if __name__ == "__main__":
    main()

class Animal:

    def __init__(self, name: str) -> None:
        self.name = name
        self.tricks: list[str] = [] #Change from class to instance attribute

    def teach_trick(self, trick_name: str) -> None:
        self.tricks.append(trick_name)

def main() -> None:
    cat: Animal = Animal("Helios")
    dog: Animal = Animal("Boomer")

    cat.teach_trick("Wash Dishes")
    cat.teach_trick("Get a job")
    print(cat.tricks)

    dog.teach_trick("Do finances")
    dog.teach_trick("Invest in stocks")
    print(dog.tricks)

if __name__ == "__main__":
    main()

    # Dunder Methods

    from typing import Self


    class Book:
        def __init__(self, title: str, pages: int) -> None:
            self.title = title
            self.pages = pages

        def __len__(self) -> int:
            return self.pages

        def __add__(self, other: Self) -> Self:
            combined_title: str = f"{self.title} & {other.title}"
            combined_pages: int = self.pages + other.pages
            return Book(combined_title, combined_pages)


    def main() -> None:
        py_daily: Book = Book("PyDaily", 100)
        harry_potter: Book = Book("Harry Potter", 340)

        print(len(py_daily))
        print(len(harry_potter))

        combined_books: Book = py_daily + harry_potter
        print(combined_books.title)
        print(combined_books.pages)


    if __name__ == "__main__":
        main()

#String and Representation

class Person:
    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age

    def __str__(self) -> str:
        return f"{self.name}: {self.age} years old"

    def __repr__(self) -> str:
        return f"Person(name={self.name}, age={self.age})"


def main() -> None:
    mario: Person = Person("Mario", 27)
    print(mario)
    print(repr(mario))

if __name__ == "__main__":
    main()

#Equality
#Comparing two objects in python

from typing import Self

class Car:
    def __init__(self, brand: str, car_id: int, colour: str) -> None:
        self.brand = brand
        self.car_id = car_id
        self.colour = colour

    def __eq__(self, other: Self) -> bool:
        print("Current:", self.__dict__)
        print("Other:", other.__dict__)
        return self.car_id == other.car_id


def main() -> None:
    car1: Car = Car("BMW", 1, "red")
    car2: Car = Car("BMW", 1, "red")

    print(car1 == car2)



if __name__ == "__main__":
    main()

#Methods vs Functions
#Methods are defined in a class
#Functions are defined outside a class

class Connection:
    def __init__(self, connection_type: str) -> None: #Dunder Method
        self.connection_type = connection_type

    def connect(self) -> None: #Regular Method
        print(f"Connecting to {self.connection_type}")

def connect(connection_type: str) -> None: #Function
    print(f"Connecting to {connection_type}")

#Chat Bot Project

from random import choice
from datetime import datetime

class ChatBot:
    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age

    def get_description(self) -> str:
        return f"{self.name} is a bot who is {self.age} years old."

    def get_response(self, text:str) -> str:
        lowered: str = text.lower()

        if "hello" in lowered:
            return f"{self.name}: Hey there!"
        elif "bye" in lowered:
            return f"{self.name}: See you!"
        elif "how old are you" in lowered:
            return f"{self.name}: I am {self.age} years old!"
        elif "what time is it" in lowered:
            now: datetime = datetime.now()
            return f"{self.name}: The current time is {now:%H:%M:%S}"
        elif "how are you" in lowered:
            return f"{self.name}: Great, thanks!"
        else:
            random_responses: list[str] = ["I don't understand...",
                                           "Would you mind rephrasing that?",
                                           "Wanyela...",
                                           "What?",
                                           "Ke eng???"]
            return f"{self.name}: {choice(random_responses)}"

    def run(self) -> None:
        while True:
            user_input: str = input("You: ")
            if user_input == "exit":
                print(f"Thank you for chatting with {self.name}!")
                break

            response: str = self.get_response(user_input)
            print(response)

def main() -> None:
    mario: ChatBot = ChatBot("Mario",27)
    print(mario.get_description())
    mario.run()

if __name__ == "__main__":
    main()
