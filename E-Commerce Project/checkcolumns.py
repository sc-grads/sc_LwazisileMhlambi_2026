from website import create_app, db
from website.models import Customer

app = create_app()
with app.app_context():
    print([c.name for c in Customer.__table__.columns])