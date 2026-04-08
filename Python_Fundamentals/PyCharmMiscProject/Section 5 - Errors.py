#User Input
import sys

total: int = 0
while True:
    user_input: str = input("Enter a Number: ")

    if user_input == "0":
        print("Total:", total)
        sys.exit()

    total += int(user_input)
    break


#Try...Except
import sys
try:
    result: float = 10/ 0
    print(result)
except Exception as e:
    print(f"Error: {e}")


total: float = 0
while True:
    user_input: str = input("Enter a number: ")

    if user_input == "0":
        print(f"Total: {total}")
        sys.exit()

    try:
        total += float(user_input)
    except ValueError:
        print("Please enter a valid number...")

#While true:
    try:
        user_input: str =  input("Enter a number: ")
        print(f"10 / {user_input} {10 / float(user_input)}")
    except ZeroDivisionError:
        print("You can't divide by 0")
    except ValueError:
        print("Please enter a valid number...")
    except Exception as e:
        print(f"Something else went wrong: {e}")

        break

#Else...Finally
user_input: str = "10"

try:
    result: float = 1 / float(user_input)
    print(f"1 / {user_input} = {result}")
except ValueError:
    print(f"You cannot use: {user_input} as a value")
except ZeroDivisionError:
    print("Don't be silly, you cannot divide by zero")
else:
    print("Success! There were no exceptions encountered")
finally:
    print("FINALLY: I am always executed!")

#Raise
def check_age(age: int) -> bool: #Manually raise issues
    if age < 0:
        raise ValueError("Not a valid age")
    elif age >= 21:
        print("You are old enough!")
        return True
    else:
        print("You are not old enough!")
        return False

check_age(-30)

#Unknown Errors
while True:
    user_input: str = input("Enter a number:")

    try:
        number: float = float(user_input)
        print(f"You entered: {number}")
    except ValueError:
        print(f"The value you entered (\"{user_input}\") is not valid")
    except Exception as e:
        print("Program encountered a new exception!")
        print(f"Type: {type(e)}")
        print(f" Error: {e}")
        break

#Letters Only Project
import string

def is_letters_only(text: str) -> None:
    alphabet: str = string.ascii_letters + " "

    for char in text:
        if char not in alphabet:
            raise ValueError ("Text can only contain letters from the alphabet!")

        print(f"\"{text}\" is letters-only, good job!")

def main() -> None:
    while True:
        try:
            user_input: str = input("Check text: ")
            is_letters_only(user_input)
        except ValueError:
            print("Please enter only letters only.")
        except Exception as e:
            print(f"Encountered an unknown exception: {type(e)} {e}")
            break
main()