import functools

user = {"username": "jose", "access_level": "guest"}

def get_admin_password():
    return "1234"

def make_secure(func):
    @functools.wraps(func)
    def secure_function():
        if user["access_level"] == "admin":
            return func()
        
    return secure_function #This a decorator

@make_secure
def get_admin_password():
    return "1234"

print(get_admin_password())
