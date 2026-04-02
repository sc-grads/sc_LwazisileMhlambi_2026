#If...Elif...Else
age: int = 30

if age >= 21:
    print("You may enter the club!")
else:
    print("You are not allowed in...")

weather: str = "cloudy"

if weather == "clear":
    print("It is a nice day")
elif weather == "cloudy":
    print("The weather could be better...")
elif weather == "rainy":
    print("What an awful day!")
else:
    print("Unknown weather")

#If...Else (Shorthand)
number: int = 10

result: str = "Above 0" if number > 0 else "0 and below" #Shorthand if

print(result)

condition: bool = False
var: str = "True" if condition else "False"

if condition:
    var: str = "True"
else:
    var: str ="False"

print(var)

#For Loop
text: str = "Hello World"

for i in range(3): #Looping 3 times
    print(f"{i}: {text}")

people: list[str] = ["Bob", "James", "Maria"]

for person in people:
    if len(person) > 4:
        print(f"{person} has a long name")
    else:
        print(f"{person} has a short name")

#While Loop
import time #Imports a built-in module

i: int = 5

while i > 0:
    print(f"Hello: {i}")
    i = i -1

connected: bool = True

while connected:
    print("Using Internet")
    time.sleep(5)
    connected = False

print("Connection ended")

while True:
    user_input: str = input("You: ")

    if user_input == "hello":
        print("Bot: Hey there!")
    else:
        print("Bot: Yes, that is interesting")

#Break and Continue
number: int = 5

while number > 0:
    number -= 1

    if number == 2:
        print("Skipping 2")
        #print("Break at 2")
        #break
        continue

    print(number)

print("Done!")

total: int = 0

print("welcome to Calc+! Add positive numbers, or insert \"0\" to exit.")
while True:
    user_input: int = int(input("Enter a number: "))

    if user_input < 0:
        print("!!!Please enter a positive number!!!")
        continue

    if user_input == 0:
        print(f"Total: {total}")
        break
    total += user_input #Increments

#Loop...Else
for i in range(3):
    print(f"Iteration: {i}")
else:
    print("Success!")

i: int = 3

while i > 0:
    i -= 1
    print("OK")
else:
    print("Success!")

#Rock, Paper, Scissors Project
import random
import sys

#Step 1: Starting Information
print("Welcome to RPS!")
moves: dict = {"rock": "🪨", "paper": "📃", "scissors": "✂️"}
valid_moves: list[str]  = list(moves.keys())

#Step 2: Infinite Loop
while True:
    user_move: str = input("Rock, Paper or Scissors? >> ").lower()
    #.lower(): Rock <-> rock

    if user_move == "exit":
        print("Thanks for playing!")
        sys.exit()

    if user_move not in valid_moves:
        print("Invalid move! Try again!")
        continue

#AI decides
    ai_move: str = random.choice(valid_moves) #Picks a random move from list

    print("----")
    print(f"You: {moves[user_move]}")
    print(f"AI: {moves[ai_move]}")
    print("----")

#Check Moves
    if user_move == ai_move:
        print("It's a draw!")
    elif user_move == "rock" and ai_move == "scissors":
            print("You win!")
    elif user_move == "scissors" and ai_move == "paper":
            print("You win!")
    elif user_move == "paper" and ai_move == "rock":
            print("You win!")
    else:
            print("You lose! AI wins...")