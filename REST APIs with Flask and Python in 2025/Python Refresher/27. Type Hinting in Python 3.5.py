def list_avg(sequence: list) -> float:
    return sum(sequence)/ len(sequence)

list_avg(123)

class Book:
    pass

class BookShelf:
    def __init__(self, books: List[Book]):
        self.books = books

    def __str__(self) -> str:
        return f"BookShelf with {leng(self.books)} books"

#Ensures that the correct data types are passed