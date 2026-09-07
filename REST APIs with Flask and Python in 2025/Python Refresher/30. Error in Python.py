def divide(dividend, divisor):
    if divisor == 0:
        raise ZeroDivisionError("Divisor cannot be 0.")
        print("Divisor cannot be 0.")
        return

    return dividend / divisor

students = [
    {"name": "Bob", "grades": [75,90]},
    {"name": "Rolf", "grades": [50]},
    {"name": "Jen", "grades": [100,90]},
]

print("welcome to the average grade program.")
try:
    for student in students:
        name = student["name"]
        grades = student["grades"]
        average = divide(sum(grades), len(grades))

except ZeroDivisionError:
    print(f"ERROR: {name} has no grades!")
else:
    print(f"The average grade is {average}.")
finally:
    print("Thank You!")
#Errors are useful for debugging
#Can use the try and catch blocks to catch the error and have python explain the error