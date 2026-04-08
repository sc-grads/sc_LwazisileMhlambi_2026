#print()
#Can pass unlimited arguments
print("A", "B", "C", sep="") #use a custom separator
print("A", "B", "C", end=".\n") #Starts on a new line
print("A", "B", "C", end="") #Brings line to previous print

people: list[str] = ["Mario", "James", "Hannah"]
print(*people, sep=", ", end=".") #*passes the list as an argument

#enumerate()
#Creates a list of tuples

elements:list[str] = ["A", "B", "C"]
for i, element in enumerate(elements, start =1):
    print(f"{i}: {element}")

#round()
a: float = 200.312399
b: float = 18.12132
c: float = 47.12312

result: float = a+b+c
print(round(result, 2))#Round to 2 decimal places
print(round(result, 1))# Round to 1 decimal place
print(round(result, 0))# Round to 0 decimal places
print(round(result, -1))# Round to nearest 10th
print(round(result, -2))# Round off to nearest 100th

#range

my_range: range = range(0, -10, -1) #specify to count up/down
print(my_range) #returns range object
print(list(my_range)) #returns range as list

#slice()

text: str = "Hello, world!"

first_three: slice = slice(0, 3)

print(text[first_three])

reverse_slice: slice = slice(None, None, -1)
print(text[reverse_slice])
print("Second Text"[reverse_slice])

step_two: slice = slice(None, None, 2)
print(text[step_two])

#globals()
#Everything that is visible in the global scope

from typing import Any

text: str = "Bob"
my_list: list[int] = [1, 2, 3]

def func() -> None:
    ...
my_globals: dict[str, Any] = dict(globals()) #converted to dictionary
print(my_globals)

for k, v in my_globals.items():#.items converts into tuple
    print(f"{k}: {v}")

#locals()
#Everything that is local to the main space

def add(a: int, b: int) -> None:
    result: int = a + b
    print(f"{a} + {b} = {result}")

    print("add() has:", locals())
    print("add() can see:", globals())

add(1,1)

#all()

wifi_enabled: bool = True
has_electricity: bool = True
has_subscription: bool = True

requirements: list[bool] =[wifi_enabled, has_electricity, has_subscription]

if all(requirements):
    print("Connected to internet")

people_voted: list[int] = [1,1,1,0,1,0,1,1,1,0]

if all(people_voted):
    print("Everyone Voted!")
else:
    print("Some people did not vote...")

#any()

people_voted: list[int] = [0, 1, 0, 0 ,0]

if any(people_voted):
    print("At least one person voted")
else:
    print("No people voted")

#isinstance()
#Checking if data type is factual
from builtins import isinstance

number: int = 10
pi: float = 3.14
text: str = "banana"
my_list: list[int] = [1, 2, 3]

print(isinstance(number,int))
print(isinstance(number,str))
print(isinstance(number,float))
print(isinstance(number,float | int)) #Either or

class Animal:
    pass

class Dog(Animal):
    pass

print(isinstance(Dog(),Animal))