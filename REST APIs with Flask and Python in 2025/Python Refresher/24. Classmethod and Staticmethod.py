class ClassTest:
    def instance_method(self): #Functions that use the object as a parameter are instance methods
        print(f"Called instance_method of {self}")

    @classmethod
    def class_method(cls):
        print(f"Called class_method of {cls}")

    @staticmethod
    def static_method():
        print("Called static_method.")


ClassTest.static_method() # Does not use an instance
#ClassTest.class_method()

test = ClassTest() # Uses a class
#test.instance_method()
#ClassTest.instance_method(test)


#Instance methods are used for calling a method and modifying the data within itself
#Class methods are used as factories
#Staic methods are used to place a method in a class

class Book:
    TYPES = ("hardcover", "paperback")

    def __init__(self, name, book_type, weight):
        self.name = name
        self.book_type = book_type
        self.weight = weight

    def __repr__(self):
        return f"<Book {self.name}, {self.book_type}, weighing {self.weight}g>"

    @classmethod
    def hardcover(cls, name, page_weight):
        return cls(name, cls.TYPES[0], page_weight + 100)

    @classmethod
    def paperback(cls, name, page_weight):
        return cls(name, cls.TYPES[1], page_weight)

book = Book.hardcover("Harry Potter", 1500)
light = Book.paperback("Python 101", 600)

print(book)
print(light)