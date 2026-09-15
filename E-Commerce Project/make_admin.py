import sys
from website import create_app, db
from website.models import Customer

app = create_app()

with app.app_context():
    email = sys.argv[1]
    user = Customer.query.filter_by(email=email).first()

    if not user:
        print(f"No user found with email: {email}")
    else:
        user.role = 'admin'
        db.session.commit()
        print(f"{email} is now an admin (role={user.role})")