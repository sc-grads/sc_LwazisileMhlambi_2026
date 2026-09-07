friends = {"Bob", "Rolf", "Anne"}
abroad ={"Bob", "Anne"}

local_friends = friends.difference(abroad)
        #returns difference between the two sets
print(local_friends)

    #Calculating a total between two sets
local = {"Rolf"}
abroad ={"Bob", "Anne"}

all_friends = local.union(abroad)
print(all_friends)

    #Finding the common elements between two sets
art = {"Bob", "Jen", "Rolf", "Charlie"}
science = {"Bob", "Jen", "Adam", "Anne"}

both = art.intersection(science)
print(both)