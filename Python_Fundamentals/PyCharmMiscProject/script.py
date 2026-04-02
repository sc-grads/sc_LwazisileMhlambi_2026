#Parameters and Arguments
def greet(name: str):#Parameter
    print(f"Hello {name}!")

greet("Mario") #Argument
greet("James")
greet("Sophia")

def greeting(name: str, language: str, default: str = "Hello"):
    if language == "it":
        print(f"Ciao {name}!")
    else:
        print(f"{default}, {name}!")

greeting(name="Mario", language="it")