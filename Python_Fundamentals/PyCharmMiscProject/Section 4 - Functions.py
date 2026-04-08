#Creating Functions
def greet():
    print("Hello!")

greet()

from datetime import datetime
import time

def show_time():
    now: datetime = datetime.now()
    print(f"Today is {now:%H:%M:%S}")

show_time()
time.sleep(2)
show_time()

#Pass
def get_status():
    pass #Ignore line of code (place-holder)

def connect_to_internet():
    pass

number: int = 2

if number > 0:
    pass
else:
    pass

def connect():
    ... #Same as pass

#Parameters and Arguments
def greet(name: str):#Parameter
    print(f"Hello {name}!")

greet("Mario") #Argument
greet("James")
greet("Sophia")

def greeting(name: str, language: str, default: str = "Hello"):
    if language == "it":
        print(f"Ciao {name}!")
    else:
        print(f"{default}, {name}!")

greeting(name="Mario", language="it")

#Return Functions
def get_length(text: str) -> int: #Get back as integer (->)
    print(f"Getting the length of: \"{text}\"...")
    return len(text)

name: str = "Mario"
length: int = get_length(name)
print(length)

def make_upper(text: str) -> str:
    return text.upper()

print(make_upper("hello"))

def connected_to_internet() -> None: #Adding an empty function
    print("Connecting to internet...")


print(connected_to_internet())

#Recursion
#def func() -> None:
#    print("Recursion")
#   func()

#func()
import time

def connected_to_internet(signal: bool, delay: int) -> None:
    if delay > 5:
        signal = True

    if signal:
        print("Connected!")
    else:
        print(f"Connection failed. Try again in: {delay}s...")
        time.sleep(delay)
        connected_to_internet(signal, delay + 2)

connected_to_internet(False, 0)

#*args and **kwargs (Arguments and Keyword Arguments)
print(1, 2, 3, "hello", sep=":") #Uses args

def add(*args: int) -> int:
    print(args)
    return sum(args)

print(add(1, 2, 3))

def greet(greeting: str, *people: str, ending: str) -> None:
    for person in people:
        print(f"{greeting}, {person}{ending}")

greet("hello", "Bob", "James", "Maria", ending="!")

def pin_position(**kwargs: int) -> None:
    print(kwargs)

pin_position(x=10, y=20) #Returns a dictionary

def funct(*args: str, default: int, **kwargs: int) -> None: #Proper syntax
    print(args)
    print(kwargs)
    print(default)

funct("a", "b", default=20, a=1, b=2)

#* & /
def func(var_a: str, /, var_b: str, *, var_e: str) -> None: #passes var_a as positional arg
    print(var_a) #var_b is passed as positional or keyword arg
    print(var_b)
    print(var_e)

func("a", "b", var_e="e")

def app(var_c: str, *, var_d: str) -> None: #everything after * as kwarg
    print(var_c)
    print(var_d)

app("c", var_d="d")

#Chat Bot Project
import sys
from datetime import datetime

def get_response(text: str) -> str:
    lowered: str = text.lower()

    if lowered in ["hello", "hi", "hey"]:
        return "Hey there!"
    elif "how are you" in lowered:
        return "I'm good thanks!"
    elif "your name" in lowered:
        return " My name is Bot :)"
    elif "time" in lowered:
        current_time: datetime = datetime.now()
        return f"The time is {current_time:%H:%M}"
    elif lowered in ["bye", "see you", "goodbye"]:
        return "It was nice talking to you! Bye!"
    else:
        return f"Sorry, I do not understand: \"{text}\"."

while True:
    user_input: str = input("You: ")

    if user_input == "exit":
        print("Bot: It was a pleasure talking to you!")
        sys.exit()

    bot_response: str = get_response(user_input)
    print(f"Bot: {bot_response}")
