#Variables in Python
    #Integers and Floats
x = 15
price = 9.99

discount = 0.2

result = price * (1 - discount)

print(result)


    #String Variables

name = "Rolf"
name = "Bob"

print(name)
print(name * 2)

    #Changing variable values
    #Variables can be re-assigned values

a  = 25
b = a

print(a)
print(b)

b = 17

print(a)
print(b)

#---------------------------------------------#

#String Formatting in Python
    #These allow us to embedd variables inside strings

name = "Bob"
greeting = f"Hello , {name}"

print(greeting)

name = "Rolf"

print(f"Hello , {name}")

    #Template strings with .format()
    #Instead of using F-strings we can use .format() to create templates

name = "Bob"
greeting = "Hello, {}"
with_name = greeting.format(name)

print(with_name)

longer_phrase = "Hello, {}. Today is {}"
formatted = longer_phrase.format("Rolf", "Monday")
    #This will put the values in the place holders

print(formatted)