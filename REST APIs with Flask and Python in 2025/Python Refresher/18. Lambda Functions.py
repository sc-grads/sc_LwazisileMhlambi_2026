#Lambda functions are functions that do not have a name and is only used to return a value
#Only used for inputs and outputs and never on actions

def add(x, y):
    return x +y

print(add(5, 7))

print((lambda x, y: x + y)(5, 7))

def double(x):
    return x * 2

sequence = [1, 3, 5, 9]
doubled = [double(x) for x in sequence]
doubled = map(double, sequence) #Does the same thing as list comprehension

doubled = [(lambda x: x * 2)(x) for x in sequence]