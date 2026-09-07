number = 7

while True: #while loop runs based on a true or false condition

    user_input = input("Would you like to play? (Y/n) ")

    if user_input == "n":
        break

    user_number = int(input("Guess our number: "))
    if user_number == number:
        print("You guessed correctly!")
    elif abs(number - user_number) == 1: #abs turns into a positive number
        print("You were off by one!")
    else:
        print("Sorry, it's wrong!")

friends = ["Rolf", "Jen", "Bob", "Anne"] #For loops are useful for looping through a list, tuple, set
for friend in friends:
    print(f"{friend} is my friend")


grades = [35, 67, 98, 100, 100]
total = sum(grades)
amount = len(grades)

for grade in grades: 
    total += grade

print(total/amount)
    

