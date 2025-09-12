import pytest
from app import create_app, db
from app.models import BugReport

@pytest.fixture
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:"
    })

    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

def test_index_page(client):
    response = client.get('/')
    assert response.status_code == 200
    # Check that the page contains the bug list container
    assert b'id="bug-list"' in response.data

def test_add_bug_form(client):
    response = client.get('/add')
    assert response.status_code == 200
    # Check that form fields exist
    assert b'name="title"' in response.data
    assert b'name="description"' in response.data
    assert b'name="priority"' in response.data

def test_add_bug_db(app, client):
    # POST a bug
    response = client.post('/add', data={
        'title': 'Test Bug',
        'description': 'This is a test bug'
    }, follow_redirects=True)
    assert response.status_code == 200

    # Verify bug is in the database
    with app.app_context():
        bug = BugReport.query.filter_by(title='Test Bug').first()
        assert bug is not None
        assert bug.description == 'This is a test bug'
