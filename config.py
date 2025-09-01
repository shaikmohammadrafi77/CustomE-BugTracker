import os

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY") or "dev_secret_key"
    SQLALCHEMY_DATABASE_URI = "sqlite:///bugs.db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
