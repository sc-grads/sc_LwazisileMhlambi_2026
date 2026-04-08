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