#Doc Strings
#They provide a description of what a module, class, function or method does.

class User:
    """ #Docstring for User class
    Base class for creating users
    """

    def __init__(self, user_id: int) -> None:
        self.user_id = user_id

    def show_id(self) -> None:
        """Prints user_id"""

        print(self.user_id)

def user_exists(user: User, database: set[User]) -> bool:
    """
    Checks if a user exists in database

    :param user: The user to check
    :param database: the database to check
    :return: bool
    """

    return user in database

def main() -> None:
    bob: User = User(0)
    anna: User = User(1)

    database: set[User] = {bob, anna}

    if user_exists(bob, database):
        print("User exists in database")
    else:
        print("User does not exist in database")

    print(User.__doc__) #Returns documentation
    print(user_exists.__doc__)

if __name__ == "__main__":
    main()

#F-Strings

var: int = 10

def add(a: int, b: int) -> int:
    return a + b

print(f"{add(5, 10) = }") #Used for displaying an equation

big_num: float = 123456789
print(f"{big_num: ,}") #Used for formating (1000 separator)
print(f"{big_num: _}")

fraction: float = 1234.5678
print(f"{fraction: .2f}") #Rounds off to 2 decimal places
print(f"{fraction:,.2f}") #Can be combined with 1000 separator

percent: float = 0.5
print(f"{percent: .1%}") #Rounds off to decimal place

char: str = "BOB"
print(f"{char:>10}: Hello") #Appears 10 spaces later, (<^>)aligns to l-c-r
print(f"{char:*>10}") #Symbol fills empty space

numbers: list[int] = [1, 100, 1_000, 10_000]
for number in numbers:
    print(f"{number:>5}: counting!") #formats everything to look good

user: str = "Lwazisile"
path: str = r'C:\Users\Desktop' #raw paths
path2: str = fr'C:\{user}\Desktop' #can be combined

#Assertions
#Checks all essentials are correct

def start_program(db: dict[int, str]) -> None:
    assert db, "Database is empty"

    print("Loaded:", db)
    print("Program started successfully!")

def main() -> None:
    db1: dict[int, str] = {0: "a", 1: "b"}
    start_program(db=db1)

if __name__ == "__main__":
    main()

var: int = -5
assert var > 0, f"{var} is not more than 0"

#Unpacking

a, b = 5, 10 #Use tuples
print(a, b)
a, b = "XY" #a: X b:Y
print(a, b)
a, *b, c = "abcdef" #tells b to absorb from b onwards. c grabs last element
print(a, b, c)
*_, last ="abcdef" #Grabs last letter
print(last)

def add(a: int, b: int) -> None:
    print(f"{a+b = }")

numbers: dict[str, int] = {"a": 5, "b": 10}
add(**numbers) #Unpacks dictionary

nums: list[int] = [1, 2, 3, 4, 5]
params: dict[str, str] = {"sep": "-", "end": "."}
print(*nums, **params)

#==VS Is
#IS is unreliable for checking values

a: int = 1000
b: int = int("1000")

print(a == b)
print(a is b)

print(f"{id(a)=}")
print(f"{id(b)=}") #Have different memory addresses

var: int | None = None

if var is None:
    print("There is no variable")
else:
    print(f"var is: {var}")

class Animal:
    ...

cat: Animal = Animal()
dog: Animal = Animal()

print(id(cat))
print(id(dog))
print(cat is dog)