# test/test.py
import pytest
from flask import url_for
from app import create_app, db
from app.models import BugReport

@pytest.fixture
def app():
    # Create a test app with a separate in-memory database
    app = create_app()
    app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:",  # in-memory db
        "WTF_CSRF_ENABLED": False
    })

    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

def test_index_page(client):
    """Test that the index page loads and returns 200"""
    response = client.get(url_for('main.index'))
    assert response.status_code == 200
    assert b"Bug Tracker" in response.data

def test_add_bug_get(client):
    """Test GET request to /add page"""
    response = client.get(url_for('main.add_bug'))
    assert response.status_code == 200
    assert b"Report a New Bug" in response.data

def test_add_bug_post(client, app):
    """Test POST request to add a bug"""
    response = client.post(url_for('main.add_bug'), data={
        "title": "Test Bug",
        "description": "This is a test bug"
    }, follow_redirects=True)
    
    # After POST, it should redirect to index
    assert response.status_code == 200
    assert b"Bug Tracker" in response.data

    # Check that the bug is in the database
    with app.app_context():
        bug = BugReport.query.filter_by(title="Test Bug").first()
        assert bug is not None
        assert bug.description == "This is a test bug"
        assert bug.id > 0
