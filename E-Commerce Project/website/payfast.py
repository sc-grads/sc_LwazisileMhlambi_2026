import hashlib
from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Cart, Order, Order_Item
from .__init__ import db

payfast_bp = Blueprint('payfast_bp', __name__)

@payfast_bp.route('/api/create-payfast-payment', methods=['POST'])
@jwt_required()
def create_payfast_payment():
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

    payfast_merchant_id = current_app.config.get('PAYFAST_MERCHANT_ID', '10000100')
    payfast_merchant_key = current_app.config.get('PAYFAST_MERCHANT_KEY', '46f0cd69e581d')
    payfast_passphrase = current_app.config.get('PAYFAST_PASSPHRASE', '')
    
    payfast_url = "https://sandbox.payfast.co.za/eng/process"

    payload = {
        'merchant_id': payfast_merchant_id,
        'merchant_key': payfast_merchant_key,
        'return_url': 'http://localhost:5173/profile/orders?payfast_success=true',
        'cancel_url': 'http://localhost:5173/cart?canceled=true',
        'notify_url': 'http://127.0.0.1:5001/api/payfast-notify',
        'name_first': customer.first_name,
        'name_last': customer.last_name,
        'email_address': customer.email,
        'amount': f"{total_amount:.2f}",
        'item_name': 'WeanerMart Order Cart (Incl. Delivery)'
    }


    return jsonify({"payfast_url": payfast_url, "payload": payload}), 200

@payfast_bp.route('/api/payfast-notify', methods=['POST'])
def payfast_notify():
    """
    PayFast ITN (Instant Transaction Notification) webhook endpoint.
    PayFast sends a POST request here when a payment status changes.
    """
    try:
        data = request.form.to_dict()
        
        # Basic validation that data was received
        if not data:
            return jsonify({"error": "No data received"}), 400

        payment_status = data.get('payment_status')
        
        if payment_status == 'COMPLETE':
            # Handle successful payment logic here (e.g., create Order records, clear Cart, etc.)
            print(f"PayFast Payment Complete for: {data.get('email_address')}")
            
        return '', 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500