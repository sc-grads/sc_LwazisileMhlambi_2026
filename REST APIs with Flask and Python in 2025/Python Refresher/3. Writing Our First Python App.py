def main():

    user_name = input("Enter you name: ")
    user_age = input("Enter you age: ")
    age = int(user_age)
    days = age * 365

    print(f"Hello, {user_name}! You are approximately {days} days old.")

if __name__ == "__main__":
    main()