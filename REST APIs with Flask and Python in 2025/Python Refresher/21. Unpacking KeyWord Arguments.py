def named(**kwargs): #(**) collects keyword arguments
    print(kwargs)

named(name="Bob", age=25)

def names(name, age):
    print(name, age)

details = {"name": "Bob", "age": 25}
named(**details)

def print_nicely(**kwargs):
    named(**kwargs)
    for arg, value in kwargs.items():
        print(f"{arg}: {value}")


print_nicely(name="Bob", age =25)

def both(*args, **kwargs):
    print(args)
    print(kwargs)

both(1, 3, 5, name="Bob", age=25)

def myfunction(**kwargs):
    print(kwargs)

myfunction(**"Bob") #Error, must be mapping
myfunction(**None) #Error