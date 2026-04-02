#Creating Functions
def greet():
    print("Hello!")

greet()

from datetime import datetime
import time

def show_time():
    now: datetime = datetime.now()
    print(f"Today is {now:%H:%M:%S}")

show_time()
time.sleep(2)
show_time()

#Pass
def get_status():
    pass #Ignore line of code (place-holder)

def connect_to_internet():
    pass

number: int = 2

if number > 0:
    pass
else:
    pass

def connect():
    ... #Same as pass