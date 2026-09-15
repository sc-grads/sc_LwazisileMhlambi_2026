from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_cors import CORS

jwt = JWTManager()

db = SQLAlchemy()
DB_NAME = 'database.sqlite3'

def create_database():
    db.create_all()
    print('Database Created')

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'asasdasdasds' #Encrypts session for authentication
    app.config['SQLALCHEMY_DATABASE_URI'] = f"sqlite:///{DB_NAME}"
    app.config['JWT_SECRET_KEY'] = 'jfhdjfhgjd'

    db.init_app(app)
    jwt.init_app(app)
    CORS(app)

    from .views import views
    from  .auth import auth
    from .admin import admin

    app.register_blueprint(views, url_prefix ='/') #localhost:5001/about-us
    app.register_blueprint(auth, url_prefix ='/') #localhost:5001/auth/sign-up
    app.register_blueprint(admin, url_prefix ='/')

    with app.app_context():
        create_database()

    return app