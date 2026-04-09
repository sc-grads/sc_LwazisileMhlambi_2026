#==VS Is
#IS is unreliable for checking values

a: int = 1000
b: int = int("1000")

print(a == b)
print(a is b)

print(f"{id(a)=}")
print(f"{id(b)=}") #Have different memory addresses

var: int | None = None

if var is None:
    print("There is no variable")
else:
    print(f"var is: {var}")

class Animal:
    ...

cat: Animal = Animal()
dog: Animal = Animal()

print(id(cat))
print(id(dog))
print(cat is dog)