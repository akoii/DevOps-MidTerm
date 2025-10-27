from flask import Blueprint

bp = Blueprint('main', __name__)

# Import routes after bp is created to avoid circular import
from api import routes
