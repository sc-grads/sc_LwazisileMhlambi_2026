import time

def connect() -> None:
    print("Connecting to internet...")
    time.sleep(1)
    print("Connected!")
    #Test module before importing

if __name__ == "__main__": #Checks if script is being run directly
    connect()