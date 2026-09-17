from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Product, Category
from .import db

admin = Blueprint('admin', __name__) #Tells python that admin endpoints live here

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
    current_price = data.get('current_price')
    previous_price = data.get('previous_price')
    in_stock = data.get('in_stock')
    picture = data.get('product_picture')
    category_id = data.get('category_id')

    if not all([name, current_price is not None, previous_price is not None, in_stock is not None, picture]):
        return jsonify({"error": "Missing required fields"}), 400

    if category_id is not None and not Category.query.get(category_id):
        return jsonify({"error": "Invalid category_id"}), 400


    new_product = Product(
        product_name=name,
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
        return jsonify({"error": "No input data provided"})

    if 'product_name' in data:
        product.product_name = data['product_name']
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
        return jsonify ({"error": "No input data provided!"}), 400

    name = data.get('name').lower()
    if not name:
        return jsonify({"error": "Category name is required!"}), 400

    if Category.query.filter_by(name=name).first():
        return jsonify({"Category already exists!"}), 400

    new_category = Category(name=name)
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

    category.name = data['name']
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