from website import create_app

app = create_app()

if __name__ == '__main__': #Only runs server in main.py file
    app.run(debug=True, port=5001) #Restarts webserver if changes are main source code