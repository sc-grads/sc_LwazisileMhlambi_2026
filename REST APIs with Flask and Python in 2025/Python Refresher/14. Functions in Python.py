def hello(): #Defining a function
    print("Hello!")

hello() #Calling a function

def user_age_in_seconds():
    user_age = int(input("Enter you age: "))
    age_seconds = user_age * 365 * 24 * 60 * 60
    print(f"Your age in seconds is {age_seconds}.")

print("Welcom to the age in seconds program!")

user_age_in_seconds()

print("Goodbye!")

#It is important to not create functions named after pre-existing functions
#Avoid creating similar variables in the global space and the functional space
#Avoid calling a function prior to creating it