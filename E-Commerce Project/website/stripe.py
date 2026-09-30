import stripe
from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Cart, Order, Order_Item
from .__init__ import db

stripe_bp = Blueprint('stripe_bp', __name__)

@stripe_bp.route('/api/create-stripe-checkout', methods=['POST'])
@jwt_required()
def create_stripe_checkout():
    current_user_id = get_jwt_identity()
    customer = Customer.query.get(current_user_id)
    
    if not customer:
        return jsonify({"error": "Customer not found"}), 404

    cart_items = Cart.query.filter_by(customer_link=customer.id).all()

    if not cart_items:
        return jsonify({"error": "Cart is empty"}), 400

    stripe.api_key = current_app.config.get('STRIPE_SECRET_KEY')

    line_items = []
    for item in cart_items:
        product = item.product
        line_items.append({
            'price_data': {
                'currency': 'zar',
                'product_data': {'name': product.product_name},
                'unit_amount': int(product.current_price * 100), # Cents
            },
            'quantity': item.quantity,
        })

    # Add Flat Delivery Fee as a line item
    shipping_fee = 250.00
    line_items.append({
        'price_data': {
            'currency': 'zar',
            'product_data': {'name': 'Flat Delivery Fee'},
            'unit_amount': int(shipping_fee * 100),
        },
        'quantity': 1,
    })

    try:
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=line_items,
            mode='payment',
            success_url='http://localhost:5173/profile/orders?success=true',
            cancel_url='http://localhost:5173/cart?canceled=true',
            customer_email=customer.email
        )
        return jsonify({"checkout_url": checkout_session.url}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500