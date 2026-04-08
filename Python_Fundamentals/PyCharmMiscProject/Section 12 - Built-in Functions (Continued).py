#callable()

fruit: str ="apple"
number: int = 10

def funct() -> None:
    print("funct() was called")

print(f"callable(): {callable(fruit)}")
print(f"callable(): {callable(number)}")
print(f"callable(): {callable(funct)}")

if callable(funct):
    funct()
else:
    print("Object not callable")

#filter()
#Memory Efficient
numbers: list[int] = list(range(1, 21))
print(numbers)

even_numbers: filter= filter(lambda n: n% 2 ==0, numbers)
print(even_numbers)

people: list[str] = ["Anna", "Bob", "Betty", "James", "John"]
long_names: filter = filter(lambda name: len(name) > 4, people)
print(list(long_names))

#map()
#Allows to map a function to an interval

numbers: list[int] = [1,2,3,4,5]

def double(number: int) -> int:
    return number * 2

doubled: map = map(double, numbers)
print(doubled)
print(list(doubled))

nums: list[int] = [1,2,3,4,5]
letters: list[str] = ["a", "b", "c"]

def combine_elements(n: int, l: str) -> tuple[int, str]:
    return n, l

combined: map = map(combine_elements, numbers, letters)
print(list(combined))

#sorted()

numbers: list[int] = [1, 10, 5, 3]
sorted_numbers: list[int] =sorted(numbers)
print(sorted_numbers)

people: list[str] = ["Mario", "James", "Anna"]
sorted_names: list[str] = sorted(people, reverse =True)
print(sorted_names) #Sorts in ascending order ASCII Value

class Animal:
    def __init__(self, name: str, weight: float) -> None:
        self.name = name
        self.weight = weight

    def __repr__(self) -> str:
        return f"{self.name}={self.weight}kg"

cat: Animal = Animal("Cat", 10)
dog: Animal = Animal("Dog", 5)
kangaroo: Animal = Animal("Kangaroo", 50)

sorted_animals: list[Animal] = sorted([cat, dog, kangaroo], key = lambda animal: animal.weight)
print(sorted_animals)

#eval()
#evaluate, run as a source
#is a security risk

result: int = eval("1+10+100")
print(result)

while True:
    user_input: str = input("Please enter an equation: ")
    print(eval(user_input))