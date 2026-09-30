import os
from dotenv import load_dotenv
load_dotenv()

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from flask_migrate import Migrate 
from sqlalchemy import MetaData  # 1. Import MetaData



jwt = JWTManager()

# 2. Define naming conventions so Alembic always knows constraint names
convention = {
    "ix": "ix_%(column_0_label)s",
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}

metadata = MetaData(naming_convention=convention)
db = SQLAlchemy(metadata=metadata)  # 3. Pass metadata into SQLAlchemy
migrate = Migrate() 
DB_NAME = 'database.sqlite3'

print("Brevo key loaded:", bool(os.getenv('BREVO_API_KEY')))

def create_database():
    db.create_all()
    print('Database Created')

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'asasdasdasds' 
    app.config['SQLALCHEMY_DATABASE_URI'] = f"sqlite:///{DB_NAME}"
    app.config['JWT_SECRET_KEY'] = 'jfhdjfhgjd'

    app.config['STRIPE_SECRET_KEY'] = os.getenv('STRIPE_SECRET_KEY')

    app.config['PAYFAST_MERCHANT_ID'] = os.getenv('PAYFAST_MERCHANT_ID', '10000100')  # Use sandbox ID for testing
    app.config['PAYFAST_MERCHANT_KEY'] = os.getenv('PAYFAST_MERCHANT_KEY','46f0cd69e581d') # Use sandbox key for testing
    app.config['PAYFAST_PASSPHRASE'] = os.getenv('PAYFAST_PASSPHRASE', '') # Use sandbox key for testing

    app.config['BREVO_API_KEY'] = os.getenv('BREVO_API_KEY')
    app.config['BREVO_SENDER_EMAIL'] = os.getenv('BREVO_SENDER_EMAIL')
    app.config['BREVO_SENDER_NAME'] = os.getenv('BREVO_SENDER_NAME')
    


    app.config['PAYSTACK_SECRET_KEY'] = os.getenv('PAYSTACK_SECRET_KEY')

    db.init_app(app)
    migrate.init_app(app, db)  
    jwt.init_app(app)
    CORS(app, origins=["http://localhost:5173"]) 

    from .views import views
    from .auth import auth
    from .admin import admin
    from .stripe import stripe_bp
    from .payfast import payfast_bp
    from .paystack import paystack_bp

    app.register_blueprint(views, url_prefix ='/') 
    app.register_blueprint(auth, url_prefix ='/') 
    app.register_blueprint(admin, url_prefix ='/')
    app.register_blueprint(stripe_bp, url_prefix ='/')
    app.register_blueprint(payfast_bp, url_prefix ='/')
    app.register_blueprint(paystack_bp, url_prefix ='/')

    with app.app_context():
        create_database()

    return app