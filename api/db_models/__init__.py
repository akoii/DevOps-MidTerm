from api import db

Base = db.Model

from .user import User
from .address import Address
