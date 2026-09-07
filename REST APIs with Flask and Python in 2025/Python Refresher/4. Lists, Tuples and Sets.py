l = ["Bob", "Rolf", "Anne"]
t = ("Bob", "Rolf", "Anne") #Can't modify a tuple
s = {"Bob", "Rolf", "Anne"} #Does not allow subscript notation

#Lists and Tuples keep the order of the elements
#Sets don't keep the order

print(l[0]) #Accessing lists and tuples using subscript notation

l[0] = "Smith" #Changing elements of a list

l.append("Smith") #Adds elements to the end of the list
print(l)

l.remove("Bob") #Removes elements from list

s.add("Smith") #Adds to set, no duplicates in sets
