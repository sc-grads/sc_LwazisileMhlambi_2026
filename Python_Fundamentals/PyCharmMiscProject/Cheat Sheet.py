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