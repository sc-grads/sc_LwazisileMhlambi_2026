#JSON
import json
data: dict = {"name": "Bob", "age": 25, "job": None}

with open("new_json.json", "w") as file:
    json.dump(data, file)
    
file_path: str = "data.json"
with open(file_path, "r") as file:

with open(file_path, "r") as file:
    data: dict = json.load(file)
    print(data)