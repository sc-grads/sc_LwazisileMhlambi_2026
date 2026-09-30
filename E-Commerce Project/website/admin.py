from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Product, Category, Order
from .import db

admin = Blueprint('admin', __name__) #Tells python that admin endpoints live here

from .email_service import send_status_update

def format_title(text):
    if not text:
        return text
    return text.strip().title()

def format_sentence(text):
    if not text:
        return text
    text = text.strip()
    if not text:
        return text
    # Capitalize the first character and keep the rest of the string as entered
    return text[0].upper() + text[1:]

#----------------------------------------------
##########USERS################################
#----------------------------------------------
@admin.route('/api/admin/users', methods=['GET'])
@jwt_required()
def get_all_users():
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    all_users = Customer.query.all()

    return jsonify([{
        "id": user.id,
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "role": user.role,
        "date_joined": user.date_joined.isoformat(),
        "address_line1": user.address_line1,
        "address_line2": user.address_line2,
        "city": user.city,
        "province": user.province,
        "postal_code": user.postal_code,
        "country": user.country
    } for user in all_users])

@admin.route('/api/admin/users/<int:user_id>/role', methods=['PUT'])
@jwt_required()
def update_user_role(user_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403
        
    user = Customer.query.get_or_404(user_id)
    data = request.get_json()
    new_role = data.get('role')
    
    if new_role not in ['customer', 'admin']:
        return jsonify({"error": "Invalid role specified"}), 400
        
    # Prevent an admin from accidentally stripping their own admin status if desired
    if user.id == current_user.id and new_role != 'admin':
        return jsonify({"error": "You cannot remove your own admin status"}), 400

    user.role = new_role
    db.session.commit()
    
    return jsonify({
        "id": user.id,
        "email": user.email,
        "role": user.role,
        "message": "User role updated successfully"
    }), 200

@admin.route('/api/admin/users/<int:user_id>', methods=['DELETE'])
@jwt_required()
def delete_user(user_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403
        
    user = Customer.query.get_or_404(user_id)
    
    if user.id == current_user.id:
        return jsonify({"error": "You cannot delete your own account"}), 400

    db.session.delete(user)
    db.session.commit()
    
    return jsonify({"message": f"User {user_id} deleted"}), 200

#----------------------------------------------
###########PRODUCTS############################
#----------------------------------------------

@admin.route('/api/admin/products', methods=['POST'])
@jwt_required()
def create_product():
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    name = data.get('product_name')
    description = data.get('description')
    current_price = data.get('current_price')
    previous_price = data.get('previous_price')
    in_stock = data.get('in_stock')
    picture = data.get('product_picture')
    category_id = data.get('category_id')

    if not all([name, current_price is not None, previous_price is not None, in_stock is not None, picture]):
        return jsonify({"error": "Missing required fields"}), 400

    if category_id is not None and not Category.query.get(category_id):
        return jsonify({"error": "Invalid category_id"}), 400

    # Apply formatting transformations
    formatted_name = format_title(name)
    formatted_description = format_sentence(description) if description else None

    new_product = Product(
        product_name=formatted_name,
        description=formatted_description,
        current_price=current_price,
        previous_price=previous_price,
        in_stock=in_stock,
        product_picture=picture,
        category_id=category_id
    )
    db.session.add(new_product)
    db.session.commit()

    return jsonify({
        "id": new_product.id,
        "product_name": new_product.product_name,
        "description": new_product.description,
        "current_price": new_product.current_price,
        "category_id": new_product.category_id
    }), 201


@admin.route('/api/admin/products/<int:product_id>', methods=['PUT'])
@jwt_required()
def update_product(product_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found"}), 404

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    if 'product_name' in data:
        product.product_name = format_title(data['product_name'])
    if 'description' in data:
        product.description = format_sentence(data['description'])
    if 'current_price' in data:
        product.current_price = data['current_price']
    if 'previous_price' in data:
        product.previous_price = data['previous_price']
    if 'in_stock' in data:
        product.in_stock = data['in_stock']
    if 'product_picture' in data:
        product.product_picture = data['product_picture']
    if 'flash_sale' in data:
        product.flash_sale = data['flash_sale']
    if 'category_id' in data:
        if data['category_id'] is not None and not Category.query.get(data['category_id']):
            return jsonify({"error": "Invalid category_id"}), 400
        product.category_id = data['category_id']

    db.session.commit()

    return jsonify({
        "id": product.id,
        "product_name": product.product_name,
        "description": product.description,
        "current_price": product.current_price,
        "previous_price": product.previous_price,
        "in_stock": product.in_stock,
        "product_picture": product.product_picture,
        "flash_sale": product.flash_sale
    }), 200

@admin.route('/api/admin/products/<int:product_id>', methods=['DELETE'])
@jwt_required()
def delete_product(product_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found"}), 404

    db.session.delete(product)
    db.session.commit()

    return jsonify({"message": f"Product {product_id} deleted"}), 200


#------------------------------------------------
#############CATEGORIES##########################
#------------------------------------------------

@admin.route('/api/admin/categories', methods=['POST'])
@jwt_required()
def create_category():
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided!"}), 400

    raw_name = data.get('name')
    if not raw_name:
        return jsonify({"error": "Category name is required!"}), 400

    formatted_name = format_title(raw_name)

    if Category.query.filter_by(name=formatted_name).first():
        return jsonify({"error": "Category already exists!"}), 400

    new_category = Category(name=formatted_name)
    db.session.add(new_category)
    db.session.commit()

    return jsonify({"id": new_category.id, "name": new_category.name}), 201


@admin.route('/api/admin/categories/<int:category_id>', methods=['PUT'])
@jwt_required()
def update_category(category_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    category = Category.query.get(category_id)
    if not category:
        return jsonify({"error": "Category not found"}), 404

    data = request.get_json()
    if not data or 'name' not in data:
        return jsonify({"error": "Name is required"}), 400

    formatted_name = format_title(data['name'])

    # Optional: check if another category with the same formatted name already exists
    existing = Category.query.filter_by(name=formatted_name).first()
    if existing and existing.id != category_id:
        return jsonify({"error": "Category name already exists"}), 400

    category.name = formatted_name
    db.session.commit()

    return jsonify({"id": category.id, "name": category.name}), 200

@admin.route('/api/admin/categories/<int:category_id>', methods=['DELETE'])
@jwt_required()
def delete_category(category_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403

    category = Category.query.get(category_id)
    if not category:
        return jsonify({"error": "Category not found"}), 404

    db.session.delete(category)
    db.session.commit()

    return jsonify({"message": f"Category {category_id} deleted"}), 200


#------------------------------------------------
#############ORDERS#############################
#------------------------------------------------

@admin.route('/api/admin/orders', methods=['GET'])
@jwt_required()
def get_all_orders():
    # 1. Get the current customer ID from the JWT token
    current_user_id = get_jwt_identity()
    customer = Customer.query.get(current_user_id)

    # 2. Verify that the user exists and is an admin
    if not customer or not customer.is_admin():
        return jsonify({"error": "Unauthorized access. Admins only."}), 403

    # 3. Fetch all orders and format them for your React frontend
    orders = Order.query.order_by(Order.date_created.desc()).all()
    orders_data = []

    for order in orders:
        cust = order.customer  # Uses relationship backref
        
        items_data = []
        for item in order.items:
            product = item.product  # Uses relationship on Order_Item
            items_data.append({
                'product_id': item.product_link,
                'product_name': product.product_name if product else 'Unknown Product',
                'product_picture': product.product_picture if product else None,
                'quantity': item.quantity,
                'price': item.price
            })

        # Fallback to Customer model address if Order record fields are None
        shipping_address = order.shipping_address or (cust.address_line1 if cust else None)
        city = order.city or (cust.city if cust else None)
        province = order.province or (cust.province if cust else None)
        postal_code = order.postal_code or (cust.postal_code if cust else None)
        phone = order.phone or (cust.phone_number if cust else None)

        orders_data.append({
            'id': order.id,
            'total_price': order.total_price,
            'status': order.status,
            'payment_id': order.payment_id,
            'date_created': order.date_created.strftime('%Y-%m-%d %H:%M:%S') if order.date_created else None,
            'customer_name': f"{cust.first_name} {cust.last_name}" if cust else 'Unknown Customer',
            'customer_email': cust.email if cust else 'No Email',
            
            # Shipping & Delivery fields added here
            'shipping_address': shipping_address,
            'city': city,
            'province': province,
            'postal_code': postal_code,
            'phone': phone,
            
            'items': items_data
        })

    return jsonify(orders_data), 200

@admin.route('/api/admin/orders/<int:order_id>/status', methods=['PUT'])
@jwt_required()
def update_order_status(order_id):
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403
 
    data = request.get_json()
    if not data or 'status' not in data:
        return jsonify({"error": "New status is required"}), 400
 
    order = Order.query.get(order_id)
    if not order:
        return jsonify({"error": "Order not found"}), 404
 
    # Update status
    order.status = data['status']
    db.session.commit()
 
    # ADDED (email): notify the customer about the new status
    order_customer = Customer.query.get(order.customer_link)
    if order_customer and order_customer.email:
        customer_name = f"{getattr(order_customer, 'first_name', '') or ''} {getattr(order_customer, 'last_name', '') or ''}".strip()
        send_status_update(order_customer.email, customer_name, order.id, order.status)
 
    return jsonify({
        "message": f"Order #{order.id} status updated to '{order.status}' successfully.",
        "order": {
            "id": order.id,
            "status": order.status,
            "total_price": order.total_price,
            "payment_id": order.payment_id,
            "customer_id": order.customer_link
        }
    }), 200
 
@admin.route('/api/admin/orders/statuses', methods=['GET'])
@jwt_required()
def get_order_statuses():
    current_user = Customer.query.get(int(get_jwt_identity()))
    if not current_user or not current_user.is_admin():
        return jsonify({"error": "Admins only"}), 403
 
    # List of available order statuses / categories
    statuses = [
        "Paid",
        "Processing",
        "Shipped",
        "Delivered",
        "Cancelled"
    ]
 
    return jsonify(statuses), 200

