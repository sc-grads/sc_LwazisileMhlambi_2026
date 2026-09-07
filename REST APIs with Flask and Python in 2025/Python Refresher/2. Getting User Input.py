#Getting user input

name = input("Enter your name: ")
print(name)

    #Doing maths with user input

size_input = input("How big is your house (in square feet): ")
square_feet = int(size_input)
square_metres = square_feet/ 10.8
print(f"{square_feet} square feet is {square_metres: .2f} square metres.")
                                        # .2f rounds off to 2 decimal places
