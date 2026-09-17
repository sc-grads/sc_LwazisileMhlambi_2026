from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Category, Product, Cart, Wishlist, Order
import uuid
from . import db
views = Blueprint('views', __name__) #Tells python that the customer endpoints live here

#------------------------------------------------
################## HOME ###########################
#------------------------------------------------
@views.route('/')
def home():
    return jsonify({"status": "API running"})

#------------------------------------------------
################## USER PROFILE ###########################
#------------------------------------------------

@views.route('/api/auth/me', methods=['GET'])
@jwt_required()
def me():
    customer_id = get_jwt_identity()
    customer = Customer.query.get(int(customer_id))
    return jsonify({
        "id": customer.id, 
        "email": customer.email, 
        "first_name": customer.first_name,
        "last_name": customer.last_name,
        "role": customer.role,
        "address_line1": customer.address_line1,
        "address_line2": customer.address_line2,
        "city": customer.city,
        "province": customer.province,
        "postal_code": customer.postal_code,
        "country": customer.country,
        "date_joined": customer.date_joined.isoformat()})

@views.route('/api/auth/me', methods=['PUT'])
@jwt_required()
def update_me():
    customer = Customer.query.get(int(get_jwt_identity()))

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    # Only update fields that were provided
    if 'first_name' in data:
        customer.first_name = data['first_name']
    if 'last_name' in data:
        customer.last_name = data['last_name']
    if 'address_line1' in data:
        customer.address_line1 = data['address_line1']
    if 'address_line2' in data:
        customer.address_line2 = data['address_line2']
    if 'city' in data:
        customer.city = data['city']
    if 'province' in data:
        customer.province = data['province']
    if 'postal_code' in data:
        customer.postal_code = data['postal_code']
    if 'country' in data:
        customer.country = data['country']

    db.session.commit()

    return jsonify({
        "id": customer.id,
        "email": customer.email,
        "first_name": customer.first_name,
        "last_name": customer.last_name,
        "role": customer.role,
        "address_line1": customer.address_line1,
        "address_line2": customer.address_line2,
        "city": customer.city,
        "province": customer.province,
        "postal_code": customer.postal_code,
        "country": customer.country
    }), 200

#------------------------------------------------
################## CATEGORIES ###########################
#------------------------------------------------

@views.route('/api/categories', methods=['GET'])
def get_categories():
    categories = Category.query.all()
    return jsonify([{"id": c.id, "name": c.name} for c in categories])

#------------------------------------------------
################## PRODUCTS ###########################
#------------------------------------------------

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

#------------------------------------------------
##################CART###########################
#------------------------------------------------

@views.route('/api/cart', methods=['GET'])
@jwt_required()
def get_cart():
    customer_id = int(get_jwt_identity())
    cart_items = Cart.query.filter_by(customer_link=customer_id).all()

    return jsonify([{
        "id": item.id,
        "product_id": item.product_link,
        "product_name": item.product.product_name,
        "current_price": item.product.current_price,
        "quantity": item.quantity,
        "subtotal": item.product.current_price * item.quantity,
        "product_picture": item.product.product_picture
    } for item in cart_items])


@views.route('/api/cart', methods=['POST'])
@jwt_required()
def add_to_cart():
    customer_id = int(get_jwt_identity())

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    product_id = data.get('product_id')
    quantity = data.get('quantity', 1)

    if not product_id:
        return jsonify({"error": "product_id is required"}), 400

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found"}), 404

    if quantity < 1:
        return jsonify({"error": "Quantity must be at least 1"}), 400

    if quantity > product.in_stock:
        return jsonify({"error": "Not enough stock available"}), 400

    # If it's already in the cart, increase quantity instead of duplicating
    existing_item = Cart.query.filter_by(customer_link=customer_id, product_link=product_id).first()

    if existing_item:
        new_quantity = existing_item.quantity + quantity
        if new_quantity > product.in_stock:
            return jsonify({"error": "Not enough stock available"}), 400
        existing_item.quantity = new_quantity
        db.session.commit()
        return jsonify({
            "id": existing_item.id,
            "product_id": existing_item.product_link,
            "quantity": existing_item.quantity
        }), 200

    new_item = Cart(customer_link=customer_id, product_link=product_id, quantity=quantity)
    db.session.add(new_item)
    db.session.commit()

    return jsonify({
        "id": new_item.id,
        "product_id": new_item.product_link,
        "quantity": new_item.quantity
    }), 201


@views.route('/api/cart/<int:cart_item_id>', methods=['DELETE'])
@jwt_required()
def remove_from_cart(cart_item_id):
    customer_id = int(get_jwt_identity())

    cart_item = Cart.query.get(cart_item_id)

    if not cart_item:
        return jsonify({"error": "Cart item not found"}), 404

    # Make sure the item actually belongs to this user — don't let anyone delete someone else's cart item
    if cart_item.customer_link != customer_id:
        return jsonify({"error": "Not authorized to remove this item"}), 403

    db.session.delete(cart_item)
    db.session.commit()

    return jsonify({"message": "Item removed from cart"}), 200

#------------------------------------------------
################## WISHLIST ###########################
#------------------------------------------------

@views.route('/api/wishlist', methods=['GET'])
@jwt_required()
def get_wishlist():
    customer_id = int(get_jwt_identity())
    wishlist_items = Wishlist.query.filter_by(customer_link=customer_id).all()

    return jsonify([{
        "id": item.id,
        "product_id": item.product_link,
        "product_name": item.product.product_name,
        "current_price": item.product.current_price,
        "product_picture": item.product.product_picture,
        "in_stock": item.product.in_stock
    } for item in wishlist_items])


@views.route('/api/wishlist', methods=['POST'])
@jwt_required()
def add_to_wishlist():
    customer_id = int(get_jwt_identity())

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    product_id = data.get('product_id')
    if not product_id:
        return jsonify({"error": "product_id is required"}), 400

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found"}), 404

    existing = Wishlist.query.filter_by(customer_link=customer_id, product_link=product_id).first()
    if existing:
        return jsonify({"error": "Product already in wishlist"}), 400

    new_item = Wishlist(customer_link=customer_id, product_link=product_id)
    db.session.add(new_item)
    db.session.commit()

    return jsonify({
        "id": new_item.id,
        "product_id": new_item.product_link
    }), 201


@views.route('/api/wishlist/<int:wishlist_item_id>', methods=['DELETE'])
@jwt_required()
def remove_from_wishlist(wishlist_item_id):
    customer_id = int(get_jwt_identity())

    wishlist_item = Wishlist.query.get(wishlist_item_id)

    if not wishlist_item:
        return jsonify({"error": "Wishlist item not found"}), 404

    if wishlist_item.customer_link != customer_id:
        return jsonify({"error": "Not authorized to remove this item"}), 403

    db.session.delete(wishlist_item)
    db.session.commit()

    return jsonify({"message": "Item removed from wishlist"}), 200

#------------------------------------------------
################## CHECKOUT ###########################
#------------------------------------------------

@views.route('/api/checkout/cart', methods=['POST'])
@jwt_required()
def checkout_cart():
    customer_id = int(get_jwt_identity())
    cart_items = Cart.query.filter_by(customer_link=customer_id).all()

    if not cart_items:
        return jsonify({"error": "Cart is empty"}), 400

    # Validate stock for everything BEFORE creating any orders
    for item in cart_items:
        if item.quantity > item.product.in_stock:
            return jsonify({
                "error": f"Not enough stock for {item.product.product_name}"
            }), 400

    created_orders = []
    fake_payment_id = f"pretend_{uuid.uuid4().hex[:12]}"  # stand-in for a real Stripe payment_intent id

    for item in cart_items:
        order = Order(
            quantity=item.quantity,
            price=item.product.current_price * item.quantity,
            status='paid',  # pretending payment succeeded instantly
            payment_id=fake_payment_id,
            customer_link=customer_id,
            product_link=item.product_link
        )
        item.product.in_stock -= item.quantity
        db.session.add(order)
        created_orders.append(order)

    # Clear the cart now that everything's been converted to orders
    for item in cart_items:
        db.session.delete(item)

    db.session.commit()

    return jsonify({
        "message": "Checkout successful (mock payment)",
        "payment_id": fake_payment_id,
        "orders": [{
            "id": order.id,
            "product_id": order.product_link,
            "quantity": order.quantity,
            "price": order.price,
            "status": order.status
        } for order in created_orders]
    }), 201

@views.route('/api/checkout/wishlist/<int:wishlist_item_id>', methods=['POST'])
@jwt_required()
def checkout_wishlist_item(wishlist_item_id):
    customer_id = int(get_jwt_identity())

    wishlist_item = Wishlist.query.get(wishlist_item_id)

    if not wishlist_item:
        return jsonify({"error": "Wishlist item not found"}), 404

    if wishlist_item.customer_link != customer_id:
        return jsonify({"error": "Not authorized to checkout this item"}), 403

    data = request.get_json() or {}
    quantity = data.get('quantity', 1)

    if not isinstance(quantity, int) or quantity < 1:
        return jsonify({"error": "Quantity must be a positive integer"}), 400

    product = wishlist_item.product

    if quantity > product.in_stock:
        return jsonify({"error": "Not enough stock available"}), 400

    fake_payment_id = f"pretend_{uuid.uuid4().hex[:12]}"

    order = Order(
        quantity=quantity,
        price=product.current_price * quantity,
        status='paid',
        payment_id=fake_payment_id,
        customer_link=customer_id,
        product_link=product.id
    )
    product.in_stock -= quantity
    db.session.add(order)
    db.session.delete(wishlist_item)
    db.session.commit()

    return jsonify({
        "message": "Checkout successful (mock payment)",
        "payment_id": fake_payment_id,
        "order": {
            "id": order.id,
            "product_id": order.product_link,
            "quantity": order.quantity,
            "price": order.price,
            "status": order.status
        }
    }), 201

#------------------------------------------------
################## VIEW ORDER HISTORY #######################
#------------------------------------------------

@views.route('/api/orders', methods=['GET'])
@jwt_required()
def get_order_history():
    customer_id = int(get_jwt_identity())
    orders = Order.query.filter_by(customer_link=customer_id).all()

    return jsonify([{
        "id": order.id,
        "product_id": order.product_link,
        "product_name": order.product.product_name,
        "product_picture": order.product.product_picture,
        "quantity": order.quantity,
        "price": order.price,
        "status": order.status,
        "payment_id": order.payment_id
    } for order in orders])
