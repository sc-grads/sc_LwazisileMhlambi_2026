#Truthy and Falsy
print(bool([]))
print(bool([None]))
print(bool([200])) #Is an actual value

#Falsy values (None, False, 0)
data: dict = {}
my_list: list = []
my_tuple: tuple = ()
empty_string: str = ""

users: dict = {1: "Mario", 2: "Luigi", 3: "James"}

if users:
    for k, v in users.items():
        print(k, v, sep=": ")
else:
    print("No data found")

#Comparing Floats
from math import isclose

a: float = .1 + .2
b: float = .3

print(f"{a} == {b}?", isclose(a, b, rel_tol = .001,))

# Scopes
number: int = 999  # Outer scope


def change_number() -> None:  # Inner Scope
    number = 10
    print(number)


print_number()
# Clash is experienced as number is defined in the outer scope

#Global
number: int = 0

def change_number() -> None:
    global number #To use variable in outer scope
    number = 10

print(number)
change_number()
print(number)

#Nonlocal
def outer_func() -> None:
    name: str = ""
    value: int = 0

    def inner_func() -> None:
        nonlocal name, value #Change variables in inner functions
        name = "Tom"
        value = 100

    inner_func()
    print(name, value)

outer_func()


