from website import create_app, db
from website.models import Product

app = create_app()
with app.app_context():
    print([c.name for c in Product.__table__.columns])