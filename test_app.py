import pytest
from app import create_app, db
from app.models import BugReport

# -----------------------------
# Fixture to create test app
# -----------------------------
@pytest.fixture
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:",  # In-memory DB for testing
        "WTF_CSRF_ENABLED": False
    })

    with app.app_context():
        db.create_all()  # Create tables
        yield app
        db.session.remove()
        db.drop_all()  # Clean up after tests

@pytest.fixture
def client(app):
    return app.test_client()

# -----------------------------
# Test 1: App creation
# -----------------------------
def test_app_creation(app):
    assert app.name == "app" or "Flask" in str(app)

# -----------------------------
# Test 2: Home page
# -----------------------------
def test_index_page(client):
    response = client.get('/')
    assert response.status_code == 200
    # Page contains 'bugs' list (empty at first)
    assert b"Add Bug" in response.data or b"bugs" in response.data

# -----------------------------
# Test 3: Add bug POST request
# -----------------------------
def test_add_bug(client):
    # Post data to /add
    response = client.post('/add', data={
        'title': 'Test Bug',
        'description': 'This is a test bug'
    }, follow_redirects=True)

    assert response.status_code == 200
    # Check if the bug is in the response
    assert b'Test Bug' in response.data
    assert b'This is a test bug' in response.data

# -----------------------------
# Test 4: Add bug GET request
# -----------------------------
def test_add_bug_get(client):
    response = client.get('/add')
    assert response.status_code == 200
    assert b"Add Bug" in response.data
