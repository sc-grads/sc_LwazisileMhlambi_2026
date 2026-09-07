#Decorators allow us to easily modify functions

user = {"username": "jose", "access_level": "guest"}

def get_admin_password():
    return "1234"

def make_secure(func):
    def secure_function():
        if user["access_level"] == "admin":
            return func()
        
    return secure_function #This a decorator

get_admin_password = make_secure(get_admin_password)

print(get_admin_password())
