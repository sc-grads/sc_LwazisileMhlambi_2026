# If statements allow us to use booleans

day_of_week = input("What day of the week is it today? ").lower()

if day_of_week == "monday":
    print("Have a great start to your week!")
elif day_of_week == "Tuesday": #Elif allows a chain of if statements
    print("It's Tuesday.")
else:
    print("Full speed ahead!")