def add (x, y): #X, Y are parameters
    result = x + y
    print(result)

add(5, 3)

def say_hello(name, surname): #Empty brackets means no parameters
    print(f"Hello!, {name} {surname}")

say_hello("Bob", "Smith") #Can't call a function without passing an argument - Bob


def divide(dividend, divisor):
    if divisor != 0:
        print(dividend/ divisor)
    else:
        print("You fool!")
divide(dividend=15, divisor= 0)