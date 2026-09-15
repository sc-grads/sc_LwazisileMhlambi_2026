from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Category, Product

views = Blueprint('views', __name__) #Tells python that the customer endpoints live here

@views.route('/')
def home():
    return jsonify({"status": "API running"})

@views.route('/api/auth/me', methods=['GET'])
@jwt_required()
def me():
    customer_id = get_jwt_identity()
    customer = Customer.query.get(int(customer_id))
    return jsonify({
        "id": customer.id, 
        "email": customer.email, 
        "username": customer.username,
        "role": customer.role})

@views.route('/api/categories', methods=['GET'])
def get_categories():
    categories = Category.query.all()
    return jsonify([{"id": c.id, "name": c.name} for c in categories])

@views.route('/api/products', methods=['GET'])
def get_products():
    category_id = request.args.get('category_id', type=int)

    query = Product.query
    if category_id is not None:
        query= query.filter_by(category_id=category_id)

    all_products = query.all()

    return jsonify([{
        "id": product.id,
        "product_name": product.product_name,
        "current_price": product.current_price,
        "previous_price": product.previous_price,
        "in_stock": product.in_stock,
        "product_picture": product.product_picture,
        "flash_sale": product.flash_sale,
        "category_id": product.category_id,
        "category_name": product.category.name if product.category else None
    }for product in all_products])

@views.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    product = Product.query.get_or_404(product_id)
    return jsonify({
        "id": product.id,
        "product_name": product.product_name,
        "current_price": product.current_price,
        "previous_price": product.previous_price,
        "in_stock": product.in_stock,
        "product_picture": product.product_picture,
        "flash_sale": product.flash_sale,
        "category_id": product.category_id,
        "category_name": product.category.name if product.category else None
    })