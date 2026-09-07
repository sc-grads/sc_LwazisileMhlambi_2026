x, y  = 5, 11 #Declaring two variables

tuple = 5, 11
x, y = tuple

print(x, y)

student_attendance = {"Rolf": 96, "Bob": 80, "Anne": 100}

print(list(student_attendance.items()))

for t in student_attendance.items():
    print(t)
#   print(f"{student}: {attendance}")

people = [("Bob", 42, "Mechanic"), ("James", 24, "Artist"), ("Harry", 32, "Lecturer")]

for name, age, profession in people:
    #These items above iterate through the list and destructure it into its 3 separte components
    print(f"Name: {name}, Age: {age}, Profession: {profession}")


person = ("Bob", 42, "Mechanic")

name, _, profession = person #Underscore is used to ignore a value in a list

head, *tail = [1,2,3,4,5] # (*)Destructures list into two depending on its position
print(head)
print(tail)