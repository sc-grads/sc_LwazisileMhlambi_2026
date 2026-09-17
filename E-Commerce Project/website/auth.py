from flask import Blueprint,request, jsonify
from flask_jwt_extended import create_access_token
from .models import Customer
from . import db
import re

auth = Blueprint('auth', __name__) #Tells python that endpoints live here

EMAIL_PATTERN = re.compile(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')

@auth.route('/api/auth/sign-up', methods=['POST'])
def sign_up():
    data = request.get_json()

    if not data:
        return jsonify({"error": "No input data provided"}), 400

    email = data.get('email')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    password1 = data.get("password1")
    password2 = data.get("password2")

    if not all([email, first_name, last_name, password1, password2]):
        return jsonify({"error": "all fields are required"}), 400

    if not EMAIL_PATTERN.match(email):
        return jsonify({"error": "Please enter a valid email address"}), 400

    if Customer.query.filter_by(email=email).first():
        return jsonify({"error": "Email already registered"}), 400

    if password1 != password2:
        return jsonify({"error": "Passwords do not match"}), 400

    password_pattern = re.compile(
        r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
)
    if not password_pattern.match(password1):
        return jsonify({
        "error": "Minimum six characters, at least one letter and one number"
    }), 400

    
    new_customer = Customer(email=email, first_name=first_name, last_name=last_name)
    new_customer.password = password1
    db.session.add(new_customer)
    db.session.commit()

    token = create_access_token(identity=str(new_customer.id))
    return jsonify({
        "token": token, 
        "first_name": new_customer.first_name,
        "last_name": new_customer.last_name
        }), 201
    

@auth.route('/api/auth/login', methods=['POST'])
def login():
    data = request.get_json()

    if not data:
        return jsonify({"error": "No input data provided"}), 400

    email = data.get('email')
    password = data.get('password')

    if not all([email, password]):
        return jsonify({"error": "Email and password are required"}), 400

    customer = Customer.query.filter_by(email=email).first()

    if not customer or not customer.verify_password(password):
        return jsonify({"error": "Invalid email or password"}), 401

    token = create_access_token(identity=str(customer.id))
    return jsonify({
        "token": token, 
        "first_name": customer.first_name,
        "last_name": customer.last_name,
        "role": customer.role
        }), 200



