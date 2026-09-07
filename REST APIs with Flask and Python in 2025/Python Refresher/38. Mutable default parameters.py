from typing import List

class Student:
    def __init__(self, name: str, grades: List[int] = None): #This is bad!
                                        #Don't make a parameter equal to a mutable value
        self.name = name
        self.grades = grades or []

    def take_exam(self, result: int):
        self.grades.append(result)

bob = Student("Bob")
rolf = Student("Rolf")
bob.take_exam(90)
print(bob.grades)
print(rolf.grades) #They will share grades

        