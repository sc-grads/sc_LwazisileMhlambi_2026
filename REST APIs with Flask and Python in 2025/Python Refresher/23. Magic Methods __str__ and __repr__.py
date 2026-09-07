class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __str__(self): #Magic method to turn an object into a string
        return f"Person {self.name}, {self.age} years old."

    def __repr__(self): #Goal is to be unambiguous, return a string to recreate original object
        return f"<Person({self.name}. {self.age})>"

    
bob = Person("Bob", 35)
print(bob)