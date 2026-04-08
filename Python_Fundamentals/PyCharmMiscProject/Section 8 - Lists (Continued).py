#List Comprehensions
numbers: list[int] = [1, 2, 3]

doubled: list[int] = []
for number in numbers:
    doubled.append(number * 2)

doubled_lc: list[int] = [number * 2 for number in numbers] #Shorthand func
print(doubled_lc)

names: list[str] = ["Mario", "James", "Luigi", "John"]
j_names: list[str] = []

for name in names:
    if name.startswith("J"):
        j_names.append(name)

j_names_lc: list[str] = [name
                         for name in names
                         if name.startswith("J")]
print(j_names_lc)

nums: list[int] = [1, 2, 4, 6, 7, 10]
even_nums: list[int] = []

for num in nums:
    if num % 2 == 0:
        even_nums.append(num)

even_nums_lc: list[int] = [num for num in nums if num % 2 == 0]
print(even_nums_lc)

#Slicing

numbers: list[int] = [1, 2, 3, 4, 5, 6]
print(numbers[0:3])
print(numbers[3:6])
print(numbers[:3])
print(numbers[3:])
print(numbers[0:4:2])
print(numbers[::2]) #Skipping numbers by 2
print(numbers[::-1]) #Reverse list

#Don't Loop and Modify

people: list[str] = ["Anna", "Bob", "Chris", "David", "Fred"]
new_people: list[str] = []

for person in people:
    print(f"- {person}, {people.index(person)}")

    if person == "Bob":
        print(f"Removing {person}")
        continue

    new_people.append(person)

print(new_people)

#Grocery List Project

import sys

def welcome_message() -> None:
    print("Welcome to Groceries!")
    print("Enter:")
    print("---------------------")
    print("1 - To add an item")
    print("2 - To remove an item")
    print("3 - To list all items")
    print("0 - To exit the program")
    print("---------------------")

def add_item(item:str, groceries: list[str]) -> None:
    groceries.append(item)
    print(f"{item} has been added!")

def remove_item(item: str, groceries: list[str]) -> None:
    try:
        groceries.remove(item)
        print(f"{item} has been removed!")
    except ValueError:
        print(f"No {item} found in {groceries}")

def display(groceries: list[str]) -> None:
    print("___LIST___")
    for i, item in enumerate(groceries, 1):
        print(f"{i}. {item.capitalize()}")

    print("_"*10)

def is_an_option(text: str) -> bool:
    return text in ["1", "2", "3", "0"]

def main() -> None:
    groceries: list[str] = []

    welcome_message()
    while True:
        user_input: str = input("Choose: ").lower()

        if not is_an_option(user_input):
            print("Please enter a valid option")
            continue

        if user_input == "1":
            new_item: str = input("What item would you like to add? >> ").lower()
            add_item(new_item, groceries)
        elif user_input == "2":
            item_to_remove: str = input("What item would you like to remove? >> ").lower()
            remove_item(item_to_remove, groceries)
        elif user_input == "3":
            display(groceries)
        elif user_input == "0":
            print("Exiting the program")
            sys.exit()

if __name__ == "__main__":
    main()
