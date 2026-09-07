friend_ages = {"Rolf": 24, "Adam": 30, "Anne": 27} #Key value pairs

friend_ages["Bob"] = 20 #Adding a record to the dictionary

print(friend_ages)

print(friend_ages["Adam"]) #Accessing a dictionary using the key

friends = [ #Creating a List of Dictionaries
    {"name": "Rolf", "age": 24},
    {"name": "Adam", "age": 30},
    {"name": "Anne", "age": 27},
]

print(friends[0]["name"]) #Accessing a list of dictionaries

student_attendance = {"Rolf": 96, "Bob": 80, "Anne": 100}

for student, attendance in student_attendance.items(): # .items() allow you to access the dictionary
    print(f"{student}: {attendance}")
