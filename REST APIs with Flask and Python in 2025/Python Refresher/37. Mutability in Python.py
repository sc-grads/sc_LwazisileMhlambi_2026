a = []
b = []

a.append(35) #Mutable or changeable


print(id(a))
print(id(b))


d = ()
c = () #Tuples are immutable


a = "hello"
b =a

print(id(a))
print(id(b))

a = a + "world"
