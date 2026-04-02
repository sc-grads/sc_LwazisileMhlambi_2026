print("Hello World")

# This is a comment

greeting = "Hello World" # Variable

#Constants
PI = 3.1415
VERSION = 2

print(VERSION)
print(PI * 2)

# Data Types

#Numeric Types
number = -100 #Integer
percent = 1.50 #Float
imaginary = 9j #Imaginary number

#Boolean Types
is_connected = True
has_money = False

#String Types
text = "Hello Bob"

#Sequence Types
numbers = [1, 2, 3] #List
coordinate = (2.5, 1.0) #Tuple

#Mapping Types
users = {"Mario": 1, "Luigi": 2} #Dictionary

#Set Types
raffle = {1, 10, 25, 50}
frozen = frozenset({1, 2, 3})

#Type Hints
number: int = 10
print(number)
print(type(number))

text: str = "Hello"

#Integers
age: int = 30
money: int = 100
self_esteem: int = -50

a: int = 5
b: int = 10

print(a + b)
print(a - b)
print(a * b)
print(a / b)

#Floats
PI: float = 3.1415
percent: float = 0.5
height_in_meters: float = 1.72

a: float = .5
b: float = 1.5

print(a + b)
print(a - b)
print(a * b)
print(a / b)

#Operators
a: int = 2
b: int = 4

print(a + b) #Add
print(a - b) #Subtract
print(a * b) #Multiply
print(a / b) #Divide
print(a // b) #Floor division (rounds off division to 0 decimal points)
print(a % b) #Modulus (gives back remainder)
print(a ** b) #Exponent function

print (10 + 10 * 2) #BODMAS

x: int = 2
x+= 2 # x = x +2
print(x)

#Comparisons
a: int = 1
b: int = 5
c: int = 10
d: int = 10

print(a == b) #Checks if two values are equal
print(c != d) #Checks if two values are not equal
print (b > a) #Checks if one value is greater than the other
print (c >= d) #Checks if greater than or equals to
print (c > b > a) #Chains the comparison operators

#Advanced Comparisons
a: int = 1
b: int = 5
c: int = 10
d: int = 10

print (c == d and b > a) #Both have to be true, else false
print (c == a or b > a) #One of them have to be true or false
print (not (a > b)) #Negate operator, checks the opposite

#Strings
#"abc" - a string of letters

name: str = "Mario\'s"
fruit: str = "Banana"
quote: str = "Quote: \"I like banana\""

print(name + " eats a " + fruit)

poem: str = """
The rock
The tree
The river
~Maya Angelou~
"""
print(poem)

#Type Conversion
txt_value: str = "100"
int_value: int = 50

print(int(txt_value) + int_value) #Changing data type from string to int
print(txt_value + str(int_value))

#Simple Adder Project
print("Welcome to you simple adder!")
print("----------------------------")

a: str = input("Enter a value for \"a\": ")
b: str = input("Enter a value for \"b\": ")
print("----------------------------")

print("The result is:", int(a) + int(b))

#Booleans
print(int(True)) #Constant value of 1
print(int(False)) #Constant value of 0

#Lists
my_list: list = [1, True, "text",[1, 2, 3]] #All valid elements

people: list[str] = ["Bob", "James", "Tom"]
print("Original:", people)

people.append("Jeremy") #Append the list
print(people)

people.remove("Bob") #Remove people
print(people)

people.pop() #Pop - remove last element from list
print(people)

people[0] = "Charlotte" #Change an element in current list
print(people)

people.insert(1, "Timothy")
print(people)

people.clear() #Clear the list
print(people)

#Tuples
items: tuple = 1, True, "Text" #Defined by comma

coordinates: tuple[float, float,] = 1.5, 2.5
print(coordinates)

new_tuple: tuple =(1, ) #Correct way to list a single tuple

#Sets
elements: set = {99, True, "Bob"} #Not indexable
print(elements)

elements.add("James") #Add elements
print(elements)

elements.remove("Bob") #Remove elements
print(elements)

elements.pop() #Pop - Remove a random item from set
print(elements)

elements.clear()
print(elements)

empty: set = set() #How empty sets should be defined

#Frozensets
things: frozenset = frozenset({1, 1, 2, 3, 3}) #Duplicates are deleted
print(things)

#Frozensets cannot be changed

#Dictionary
users: dict = {1: "Bob", 2: "Luigi"} #Key-value pairs
users[3] = "Mario" #Adds a 3rd key-value pair
users.pop(2) #Deletes Luigi
empty: dict ={}
print(users)
print(empty)
print(users[2])

weather: dict = {"time": "12:00",
                 "weather": {"morning": "rain",
                             "evening": "more rain"}}
print(weather["time"])
print(weather["weather"])
print(weather["weather"]["morning"])

#None
no_value: None = None
print(no_value)
print(type(no_value))

users: dict = {1: "Mario", 2: "Luigi"}
print(users.get(3)) #To get a specific key in the dictionary

possible_user: str | None = users.get(3) #Creates an option

print(possible_user)

#None
no_value: None = None
print(no_value)
print(type(no_value))

users: dict = {1: "Mario", 2: "Luigi"}
print(users.get(3)) #To get a specific key in the dictionary

possible_user: str | None = users.get(3) #Creates an option

print(possible_user)

#Mad Libs Project
name: str = input("Enter a name: ")
noun_a: str = input("Enter a noun: ")
verb_a: str = input("Enter a verb: ")
noun_b: str = input("Enter a noun: ")
verb_b: str = input("Enter a verb (past tense): ")
number_a = int(input("Enter a number: "))
number_b = int(input("Enter another  number: "))

story: str = f"""
---------------------------------------------------------------
This is a story about {name}, a strong (and beautiful) {noun_a}
who loved to {verb_a}. 

{name} once {verb_b} and won a {noun_b} as a prize.
Isn't that incredible?

Today, {name} is {int(number_a) + int(number_b)} years old and 
has retired from all adventures.

But the story will live on forever...
---------------------------------------------------------------
"""
print(story)