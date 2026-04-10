#Introduction
#Opening and Closing a file using with

from typing import TextIO

file_path: str = "info.txt"

with open(file_path, "r") as f:
    print(f.read())

try:
    file: TextIO = open(file_path, "r")
    text: str = file.read()

    raise Exception("Unknown exception...")
    print(text)
except FileNotFoundError:
    print("Could not find the file...")
except Exception as e:
    print(e)
finally:
    print("Force closing the file")
    file.close()

#Reading

file_path: str = "info.txt"

with open(file_path, "r") as f:
    text: str = f.read()#Is exhaustive
    #print(f.read(5)) specify the bytes
    #print(f.readline())

#Appending

file_path: str = "info.txt"

with open(file_path, "a") as txt:
    txt.write("I am some text!\an")

#Writing

file_path: str = "info.txt"

with open("info.txt", "w") as txt:
    txt.write("I am some text!\a")

#JSON

file_path: str = "data.json"
with open(file_path, "r") as file:

with open(file_path, "r") as file:
    data: dict = json.load(file)
    print(data)

# JSON
import json

data: dict = {"name": "Bob", "age": 25, "job": None}

with open("new_json.json", "w") as file:
    json.dump(data, file)

file_path: str = "data.json"
with open(file_path, "r") as file:

with open(file_path, "r") as file:
    data: dict = json.load(file)
    print(data)