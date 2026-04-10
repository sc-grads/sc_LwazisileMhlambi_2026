#@dataclass
#helps you write classes that mainly store data by generating methods
# like __init__, __repr__, and comparisons
from dataclasses import dataclass

@dataclass #annotate
class Coin:
    name:str
    value: float
    id: str

def main() -> None:
    bitcoin: Coin = Coin("Bitcoin", 10_000, "BTC")
    bitcoin2: Coin = Coin("Bitcoin", 10_000, "BTC")
    ripple: Coin = Coin("Ripple", 10_000, "XRP")

    print(bitcoin)
    print(ripple)

    print(bitcoin == ripple)
    print(bitcoin == bitcoin2)

if __name__ == "__main__":
    main()

#Fields

from dataclasses import dataclass, field

@dataclass
class Fruit:
    name: str
    grams: float
    price_per_kg: float
    edible: bool = field(default=True) #Setting default value
    related_fruits: list[str] = field(default_factory=list)


def main() -> None:
    apple: Fruit = Fruit("Apple", 100, 5)
    pear: Fruit = Fruit("Pear", 250, 10, related_fruits=["Apple", "Orange"])
    print(apple)
    print(pear)
    print(pear.related_fruits)

if __name__ == "__main__":
    main()

#__post_init__
#Allows code to run after the initial initialiser

from dataclasses import dataclass, field

@dataclass
class Fruit:
    name: str
    grams: float
    price_per_kg: float
    total_price: float = field(init=False)

    def __post_init__(self) -> None:
        self.total_price = (self.grams /1000) * self.price_per_kg

    def describe(self) -> None:
        print(f"{self.grams}g of {self.name} costs ${self.total_price}")

def main() -> None:
    apple: Fruit = Fruit("Apple", 1500, 5)
    orange: Fruit = Fruit("Orange", 2500, 10)

    apple.describe()
    orange.describe()



if __name__ == "__main__":
    main()

#InitVar
#declare fields that are intended to be used only during the
# initialization of the instance, meaning they won't be stored
# as attributes of the instance itself

from dataclasses import dataclass, field, InitVar

@dataclass
class Fruit:
    name: str
    grams: float
    price_per_kg: float
    is_rare: InitVar[bool | None] = None
    total_price: float = field(init=False)

    def __post_init__(self, is_rare: bool | None) -> None:
        if is_rare:
            self.price_per_kg *= 2

        self.total_price = (self.grams /1000) * self.price_per_kg

    def describe(self) -> None:
        print(f"{self.grams}g of {self.name} costs ${self.total_price}")

def main() -> None:
    apple: Fruit = Fruit("Apple", 1500, 5)
    orange: Fruit = Fruit("Orange", 2500, 10)
    passion: Fruit = Fruit("Passion", 100, 50, is_rare=True)


    apple.describe()
    orange.describe()
    passion.describe()



if __name__ == "__main__":
    main()

#@property
#define a method as a property, allowing you to access it like an attribute
from dataclasses import dataclass, field, InitVar

@dataclass
class Fruit:
    name: str
    grams: float
    price_per_kg: float

    @property
    def total_price(self) -> float:
        return (self.grams / 1000) * self.price_per_kg

    def describe(self) -> None:
        print(f"{self.grams}g of {self.name} costs ${self.total_price}")

def main() -> None:
    apple: Fruit = Fruit("Apple", 1500, 5)
    print(apple)
    apple.describe()
    apple.price_per_kg =20
    print(apple)
    apple.describe()

if __name__ == "__main__":
    main()

#Notes Project

from dataclasses import dataclass, field
from uuid import uuid4, UUID

@dataclass
class Note:
    id: UUID = field(init=False)
    title: str
    body:

    def __post_init__(self) -> None:
        self.id = uuid4()

class NoteApp:
    def __init__(self, author: str, notes: list[Note] | None = None) -> None:
        self.author = author

        if notes is None:
            self._notes = []
        else:
            self._notes = notes

        self.display_instructions()

    @staticmethod
    def display_instructions() -> None:
        print("welcome to Notes!")
        print("Here are the commands: ")
        print("1 - Add a new note")
        print("2 - Edit note")
        print("3 - Delete note")
        print("4 - Display all notes")

    def add_note(self) -> None:
        title: str = input("Title: ")
        body: str = input("Body: ")

        note: Note = Note(title, body)
        self._notes.append(note)
        print("Note was added!")

    def _edit_note(self) -> None:
        print("Which note would you like to edit?")
        self._show_notes()


        try:
            note_index: int = int(input("Index: ")) -1
            current: Note = self._notes[note_index]

            new_title: str =input("New title: ")
            new_body: str =input("New body: ")

            current.title = new_title
            current.body = new_body
            print("Note edited!")
        except IndexError:
            print("Invalid index!")
            self._edit_note()
        except ValueError:
            print("Index cannot be empty...")
            print("Aborting operation")


def main() -> None:
    ...

if __name__ == "__main__":
    main()