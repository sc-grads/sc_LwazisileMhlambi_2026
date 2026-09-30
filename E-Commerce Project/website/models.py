from . import db
from flask_login import UserMixin
from datetime import datetime, timezone
from werkzeug.security import generate_password_hash, check_password_hash

class Customer(db.Model, UserMixin): #UserMixin allows us to use flask login for authentication
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(100), unique=True)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    phone_number = db.Column(db.String(20), nullable=True)
    password_hash = db.Column(db.String(150))
    date_joined = db.Column(db.DateTime(), default=lambda: datetime.now(timezone.utc))

    role = db.Column(db.String(20), nullable=False, default='customer')

    address_line1 = db.Column(db.String(200), nullable=True)
    address_line2 = db.Column(db.String(200), nullable=True)
    city = db.Column(db.String(100), nullable=True)
    province = db.Column(db.String(100), nullable=True)
    postal_code = db.Column(db.String(20), nullable=True)
    country = db.Column(db.String(100), nullable=True)

    cart_items = db.relationship('Cart', backref=db.backref('customer', lazy=True))
    orders = db.relationship('Order', backref=db.backref('customer', lazy=True))
    wishlist_items = db.relationship('Wishlist', backref=db.backref('customer', lazy=True))

    @property
    def password(self):
        raise AttributeError('Password is not a readable attribute')

    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password=password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password=password)

    def is_admin(self):
        return self.role == 'admin'

    def __str__(self):
        return '<Customer %r>' % self.id

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_name = db.Column(db.String(100), nullable=False)
    current_price = db.Column(db.Float, nullable =False)
    previous_price = db.Column(db.Float, nullable =False)
    description = db.Column(db.Text, nullable=True)
    in_stock = db.Column(db.Integer, nullable=False)
    product_picture = db.Column(db.String(1000), nullable=False)
    flash_sale = db.Column(db.Boolean, default=False)
    date_added = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    category_id = db.Column(db.Integer, db.ForeignKey('category.id'), nullable=True)

    carts = db.relationship('Cart', backref=db.backref('product', lazy=True))
    # Removed the invalid direct 'orders' relationship. Use product.order_items instead.
    wishlist_entries = db.relationship('Wishlist', backref=db.backref('product', lazy=True))

    def __str__(self):
        return '<Product %r' % self.product_name

class Cart(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    quantity = db.Column(db.Integer, nullable=False)

    customer_link = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    product_link = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)

    def __str__(self):
        return '<Cart %r>' % self.id

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique = True)

    products = db.relationship('Product', backref=db.backref('category', lazy=True))

    def __str__(self):
        return '<Category %r>' % self.name

class Order(db.Model):
    __tablename__ = 'order'
    id = db.Column(db.Integer, primary_key=True)
    total_price = db.Column(db.Float, nullable=False)
    status = db.Column(db.String(100), nullable=False, default='Pending')
    payment_id = db.Column(db.String(1000), nullable=False)
    date_created = db.Column(db.DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))

    customer_link = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    
    # --- New Shipping Address Fields ---
    shipping_address = db.Column(db.String(250), nullable=True)
    city = db.Column(db.String(100), nullable=True)
    province = db.Column(db.String(100), nullable=True)
    postal_code = db.Column(db.String(20), nullable=True)
    phone = db.Column(db.String(20), nullable=True)

    items = db.relationship('Order_Item', backref='order', cascade='all, delete-orphan', lazy=True)

    def __str__(self):
        return f'<Order {self.id}>'
    
class Order_Item(db.Model):
    __tablename__ = 'order_item'
    id = db.Column(db.Integer, primary_key=True)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Float, nullable=False)  # Price at the time of purchase

    order_link = db.Column(db.Integer, db.ForeignKey('order.id'), nullable=False)
    product_link = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)

    product = db.relationship('Product', backref=db.backref('order_items', lazy=True))

    def __str__(self):
        return f'<Order_Item {self.id}>'

class Wishlist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date_added = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    customer_link = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    product_link = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)

    def __str__(self):
        return '<Wishlist %r>' % self.id