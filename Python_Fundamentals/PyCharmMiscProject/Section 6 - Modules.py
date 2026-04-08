#Modules
import greetings as g #Creates alias

g.greet("Mario")
print(g.AUTHOR)

#Importing *
#Interferes with other imports
from my_time import *
from time import *

print(date())
print(time())

#if __name__ == "__main__"
import connections

if __name__ == "__main__":
    connections.connect()

#Packages
from library.my_package import website, internet

internet.connect()
website.load("www.google.com")

#Website Status Project
import requests
from requests import Response

def get_response(url: str) -> Response:
    return requests.get(url)

def show_response_info(response: Response) -> None:
    print("Status:", response.status_code)
    print("OK", response.ok)
    print("Links:", response.links)
    print("Encoding:", response.encoding)
    print("Is redirect:", response.is_redirect)
    print("Is permanent redirect", response.is_permanent_redirect)

def main() -> None:
    website: str = "https://www.indently.io/"
    response: Response = get_response(website)
    show_response_info(response)

    if __name__ == "__main__":
        main()