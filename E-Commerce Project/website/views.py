from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from .models import Customer, Category, Product, Cart, Wishlist, Order, Order_Item
from datetime import datetime, timedelta,timezone
import uuid
from . import db
views = Blueprint('views', __name__) #Tells python that the customer endpoints live here

from .email_service import get_buyer_details, send_order_confirmation

def format_title(text):
    if not text:
        return text
    return text.strip().title()

def get_shipping_fields(data):
    s = (data or {}).get('shipping_details') or {}
    return {
        'shipping_address': s.get('address'),
        'city': s.get('city'),
        'province': s.get('province'),
        'postal_code': s.get('postalCode') or s.get('postal_code'),
        'phone': s.get('phone'),
    }

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
        "phone_number": customer.phone_number, # Added phone number here
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
        customer.first_name = format_title(data['first_name'])
    if 'last_name' in data:
        customer.last_name = format_title(data['last_name'])
    if 'phone_number' in data: # Added handling for updating phone number
        customer.phone_number = data['phone_number']
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
        "phone_number": customer.phone_number, # Included in response
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
        "description": product.description,
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
        "description": product.description,
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

@views.route('/api/cart/<int:cart_item_id>', methods=['PUT'])
@jwt_required()
def update_cart_quantity(cart_item_id):
    customer_id = int(get_jwt_identity())

    cart_item = Cart.query.get(cart_item_id)
    if not cart_item:
        return jsonify({"error": "Cart item not found"}), 404

    if cart_item.customer_link != customer_id:
        return jsonify({"error": "Not authorized to update this item"}), 403

    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    quantity = data.get('quantity')
    if quantity is None:
        return jsonify({"error": "quantity is required"}), 400

    if quantity < 1:
        return jsonify({"error": "Quantity must be at least 1"}), 400

    # Check against product stock availability
    product = Product.query.get(cart_item.product_link)
    if product and quantity > product.in_stock:
        return jsonify({"error": "Not enough stock available"}), 400

    cart_item.quantity = quantity
    db.session.commit()

    return jsonify({
        "id": cart_item.id,
        "product_id": cart_item.product_link,
        "quantity": cart_item.quantity,
        "subtotal": product.current_price * cart_item.quantity if product else 0
    }), 200

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

@views.route('/api/wishlist/add-all-to-cart', methods=['POST'])
@jwt_required()
def add_all_to_cart():
    customer_id = int(get_jwt_identity())
    wishlist_items = Wishlist.query.filter_by(customer_link=customer_id).all()

    if not wishlist_items:
        return jsonify({"error": "No items in wishlist to add to cart"}), 400

    for item in wishlist_items:
        # Check if product is already in the user's cart
        existing_cart_item = Cart.query.filter_by(
            customer_link=customer_id, 
            product_link=item.product_link
        ).first()

        if existing_cart_item:
            existing_cart_item.quantity += 1
        else:
            new_cart_item = Cart(
                customer_link=customer_id, 
                product_link=item.product_link, 
                quantity=1
            )
            db.session.add(new_cart_item)

        db.session.delete(item)

    db.session.commit()
    return jsonify({"message": "All wishlist items added to cart successfully"}), 200

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

    # Extract JSON payload and shipping details sent from frontend
    data = request.get_json() or {}
    shipping_details = data.get('shipping_details', {})

    # Validate stock for everything BEFORE creating any orders
    for item in cart_items:
        if item.quantity > item.product.in_stock:
            return jsonify({
                "error": f"Not enough stock for {item.product.product_name}"
            }), 400

    fake_payment_id = f"pretend_{uuid.uuid4().hex[:12]}" 

    try:
        # Calculate total price for the entire order
        total_order_price = sum(item.product.current_price * item.quantity for item in cart_items)

        # 1. Create the single parent Order record including shipping details
        new_order = Order(
            total_price=total_order_price,
            status='paid',
            payment_id=fake_payment_id,
            customer_link=customer_id,
            date_created=datetime.now(timezone.utc),
            shipping_address=shipping_details.get('address'),
            city=shipping_details.get('city'),
            province=shipping_details.get('province'),
            postal_code=shipping_details.get('postalCode'),
            phone=shipping_details.get('phone')
        )
        db.session.add(new_order)
        db.session.flush() # Flushes so new_order.id is generated for the children items

        created_order_items = []

        # 2. Create Order_Item records for each product in the cart
        for item in cart_items:
            item_total_price = item.product.current_price * item.quantity
            
            order_item = Order_Item(
                quantity=item.quantity,
                price=item_total_price,
                order_link=new_order.id,
                product_link=item.product_link
            )
            db.session.add(order_item)
            created_order_items.append(order_item)

            # Deduct stock
            item.product.in_stock -= item.quantity

        # 3. Clear the cart
        for item in cart_items:
            db.session.delete(item)

        db.session.commit()

        # 4. Return response including shipping details & formatted timestamp
        return jsonify({
            "message": "Checkout successful (mock payment)",
            "payment_id": fake_payment_id,
            "order": {
                "id": new_order.id,
                "total_price": new_order.total_price,
                "status": new_order.status,
                "date_created": new_order.date_created.strftime('%d/%m/%Y %H:%M'),
                "shipping_address": new_order.shipping_address,
                "city": new_order.city,
                "province": new_order.province,
                "postal_code": new_order.postal_code,
                "phone": new_order.phone,
                "items": [{
                    "product_id": oi.product_link,
                    "product_name": oi.product.product_name if hasattr(oi, 'product') else "Product",
                    "quantity": oi.quantity,
                    "price": oi.price
                } for oi in created_order_items]
            }
        }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

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

@views.route('/api/checkout/stripe-success', methods=['POST'])
@jwt_required()
def stripe_success():
    customer_id = int(get_jwt_identity())
    
    # 🛑 GUARD: Prevent duplicate orders within 15 seconds
    recent_threshold = datetime.utcnow() - timedelta(seconds=15)
    recent_order = Order.query.filter(
        Order.customer_link == customer_id,
        Order.date_created >= recent_threshold
    ).first()
 
    if recent_order:
        return jsonify({"message": "Order already processed recently", "order_id": recent_order.id}), 200
 
    cart_items = Cart.query.filter_by(customer_link=customer_id).all()
 
    if not cart_items:
        return jsonify({"message": "Cart already processed or empty"}), 200
 
    # Validate stock again just in case
    for item in cart_items:
        if item.quantity > item.product.in_stock:
            return jsonify({"error": f"Not enough stock for {item.product.product_name}"}), 400
 
    payment_id = f"stripe_{uuid.uuid4().hex[:12]}"
 
    try:
        subtotal = sum(item.product.current_price * item.quantity for item in cart_items)
        shipping_fee = 250.00
        total_order_price = subtotal + shipping_fee
 
        shipping = get_shipping_fields(request.get_json(silent=True))  # ADDED
 
        # ADDED (email): capture email details BEFORE the cart is cleared
        buyer = get_buyer_details(request.get_json(silent=True))
        email_items = [
            {
                "name": item.product.product_name,
                "quantity": item.quantity,
                "price": item.product.current_price * item.quantity
            }
            for item in cart_items
        ]
 
        # 1. Create Order record including delivery fee in total price
        new_order = Order(
            total_price=total_order_price,
            status='paid',
            payment_id=payment_id,
            customer_link=customer_id,
            date_created=datetime.utcnow(),
            **shipping  # ADDED
        )
        db.session.add(new_order)
        db.session.flush()
 
        created_order_items = []
 
        # 2. Create Order Items & Deduct Stock
        for item in cart_items:
            item_total_price = item.product.current_price * item.quantity
            
            order_item = Order_Item(
                quantity=item.quantity,
                price=item_total_price,
                order_link=new_order.id,
                product_link=item.product_link
            )
            db.session.add(order_item)
            created_order_items.append(order_item)
 
            item.product.in_stock -= item.quantity
 
        # 3. Clear the Cart
        for item in cart_items:
            db.session.delete(item)
 
        db.session.commit()
 
        # ADDED (email): send the purchase confirmation (a failed email never breaks the order)
        send_order_confirmation(new_order.id, buyer, email_items, total_order_price, shipping)
 
        return jsonify({"message": "Order successfully placed via Stripe", "order_id": new_order.id}), 201
 
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
 
@views.route('/api/checkout/paystack-success', methods=['POST'])
@jwt_required()
def paystack_success():
    import uuid
    from datetime import datetime, timedelta
 
    current_user_id = int(get_jwt_identity())
 
    try:
        # 🛑 CRITICAL RACE-CONDITION FIX: Use database transaction isolation or 
        # check recent orders within a very tight window (e.g., last 3 seconds)
        recent_threshold = datetime.utcnow() - timedelta(seconds=3)
        recent_order = Order.query.filter(
            Order.customer_link == current_user_id,
            Order.date_created >= recent_threshold
        ).first()
 
        if recent_order:
            return jsonify({"message": "Order already processed recently", "order_id": recent_order.id}), 200
 
        # Fetch cart items
        cart_items = Cart.query.filter_by(customer_link=current_user_id).all()
 
        if not cart_items:
            return jsonify({"message": "Cart already processed or empty"}), 200
 
        for item in cart_items:
            if item.quantity > item.product.in_stock:
                return jsonify({"error": f"Not enough stock for {item.product.product_name}"}), 400
 
        payment_id = f"paystack_{uuid.uuid4().hex[:12]}"
 
        subtotal = sum(item.product.current_price * item.quantity for item in cart_items)
        shipping_fee = 250.00
        total_order_price = subtotal + shipping_fee
 
        shipping = get_shipping_fields(request.get_json(silent=True))  # ADDED
 
        # ADDED (email): capture email details BEFORE the cart is cleared
        buyer = get_buyer_details(request.get_json(silent=True))
        email_items = [
            {
                "name": item.product.product_name,
                "quantity": item.quantity,
                "price": item.product.current_price * item.quantity
            }
            for item in cart_items
        ]
 
        new_order = Order(
            total_price=total_order_price,
            status='paid',
            payment_id=payment_id,
            customer_link=current_user_id,
            date_created=datetime.utcnow(),
            **shipping  # ADDED
        )
        db.session.add(new_order)
        db.session.flush()
 
        for item in cart_items:
            item_total_price = item.product.current_price * item.quantity
            order_item = Order_Item(
                quantity=item.quantity,
                price=item_total_price,
                order_link=new_order.id,
                product_link=item.product_link
            )
            db.session.add(order_item)
            item.product.in_stock -= item.quantity
 
        # Delete the cart items immediately
        for item in cart_items:
            db.session.delete(item)
 
        db.session.commit()
 
        # ADDED (email): send the purchase confirmation (a failed email never breaks the order)
        send_order_confirmation(new_order.id, buyer, email_items, total_order_price, shipping)
 
        return jsonify({"message": "Order successfully placed via PayStack", "order_id": new_order.id}), 201
 
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
 
@views.route('/api/checkout/payfast-success', methods=['POST'])
@jwt_required()
def payfast_success():
    customer_id = int(get_jwt_identity())
 
    recent_threshold = datetime.utcnow() - timedelta(seconds=15)
    recent_order = Order.query.filter(
        Order.customer_link == customer_id,
        Order.date_created >= recent_threshold
    ).first()
 
    if recent_order:
        return jsonify({"message": "Order already processed recently", "order_id": recent_order.id}), 200
 
    cart_items = Cart.query.filter_by(customer_link=customer_id).all()
    if not cart_items:
        return jsonify({"message": "Cart already processed or empty"}), 200
 
    payment_id = f"payfast_{uuid.uuid4().hex[:12]}"
 
    subtotal = sum(item.product.current_price * item.quantity for item in cart_items)
    shipping_fee = 250.00
    total_order_price = subtotal + shipping_fee
 
    shipping = get_shipping_fields(request.get_json(silent=True))  # ADDED
 
    # ADDED (email): capture email details BEFORE the cart is cleared
    buyer = get_buyer_details(request.get_json(silent=True))
    email_items = [
        {
            "name": item.product.product_name,
            "quantity": item.quantity,
            "price": item.product.current_price * item.quantity
        }
        for item in cart_items
    ]
 
    new_order = Order(
        total_price=total_order_price,
        status='paid',
        payment_id=payment_id,
        customer_link=customer_id,
        date_created=datetime.utcnow(),
        **shipping  # ADDED
    )
    db.session.add(new_order)
    db.session.flush()
 
    for item in cart_items:
        item_total_price = item.product.current_price * item.quantity
        order_item = Order_Item(
            quantity=item.quantity,
            price=item_total_price,
            order_link=new_order.id,
            product_link=item.product_link
        )
        db.session.add(order_item)
        item.product.in_stock -= item.quantity
        db.session.delete(item)
 
    db.session.commit()
 
    # ADDED (email): send the purchase confirmation (a failed email never breaks the order)
    send_order_confirmation(new_order.id, buyer, email_items, total_order_price, shipping)
 
    return jsonify({"message": "Order successfully placed via PayFast", "order_id": new_order.id}), 201

#------------------------------------------------
################## VIEW ORDER HISTORY #######################
#------------------------------------------------

@views.route('/api/orders', methods=['GET'])
@jwt_required()
def get_order_history():
    customer_id = int(get_jwt_identity())
    # Fetch orders for this customer, sorted by newest first
    orders = Order.query.filter_by(customer_link=customer_id).order_by(Order.date_created.desc()).all()

    return jsonify([{
        "id": order.id,
        "total_price": order.total_price,
        "status": order.status,
        "payment_id": order.payment_id,
        "date_created": order.date_created.strftime('%d/%m/%Y %H:%M') if order.date_created else None,
        
        # Shipping address details
        "shipping_address": getattr(order, 'shipping_address', None) or getattr(order, 'address', None),
        "city": getattr(order, 'city', None),
        "province": getattr(order, 'province', None) or getattr(order, 'state', None),
        "postal_code": getattr(order, 'postal_code', None) or getattr(order, 'zip_code', None),
        "phone": getattr(order, 'phone', None) or getattr(order, 'phone_number', None),

        "items": [{
            "product_id": item.product_link,
            "product_name": item.product.product_name if item.product else "Product",
            "product_picture": item.product.product_picture if item.product else None,
            "quantity": item.quantity,
            "price": item.price
        } for item in order.items]
    } for order in orders]), 200
