#eval()
#evaluate, run as a source
#is a security risk

result: int = eval("1+10+100")
print(result)

while True:
    user_input: str = input("Please enter an equation: ")
    print(eval(user_input))