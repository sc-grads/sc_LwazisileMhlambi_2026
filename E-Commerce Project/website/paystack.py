import requests
from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Cart, Order, Order_Item
from .__init__ import db

paystack_bp = Blueprint('paystack_bp', __name__)

@paystack_bp.route('/api/create-paystack-payment', methods=['POST'])
@jwt_required()
def create_paystack_payment():
    current_user_id = get_jwt_identity()
    customer = Customer.query.get(current_user_id)
    
    if not customer:
        return jsonify({"error": "Customer not found"}), 404

    cart_items = Cart.query.filter_by(customer_link=customer.id).all()

    if not cart_items:
        return jsonify({"error": "Cart is empty"}), 400

    subtotal = sum(item.product.current_price * item.quantity for item in cart_items)
    shipping_fee = 250.00
    total_amount = subtotal + shipping_fee  # <--- Include delivery fee
    
    amount_in_cents = int(total_amount * 100)

    paystack_secret_key = current_app.config.get('PAYSTACK_SECRET_KEY')
    
    headers = {
        "Authorization": f"Bearer {paystack_secret_key}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "email": customer.email,
        "amount": amount_in_cents,
        "currency": "ZAR",
        "callback_url": "http://localhost:5173/profile/orders?paystack_success=true",
        "metadata": {
            "customer_name": f"{customer.first_name} {customer.last_name}"
        }
    }

    try:
        response = requests.post("https://api.paystack.co/transaction/initialize", json=payload, headers=headers)
        res_data = response.json()

        if response.status_code != 200 or not res_data.get("status"):
            return jsonify({"error": res_data.get("message", "Paystack initialization failed")}), 400

        authorization_url = res_data["data"]["authorization_url"]
        return jsonify({"authorization_url": authorization_url}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
