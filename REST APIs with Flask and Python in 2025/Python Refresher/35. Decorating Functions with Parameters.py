import functools

user = {"username": "jose", "access_level": "guest"}

def get_admin_password():
    return "1234"

def make_secure(func):
    @functools.wraps(func)
    def secure_function(panel):
        if user["access_level"] == "admin":
            return func(panel)
        
    return secure_function #This a decorator

@make_secure
def get_admin_password(panel):
    if panel == "admin":
        return "1234"
    elif panel == "billing":
        return "super_secure_password"

print(get_admin_password("billing"))
