from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_health():
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json() == {'status': 'ok'}


def test_connections():
    response = client.get('/connections')
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert response.json()[0]['departure'] == 'Berlin'


def test_cities_and_asset():
    response = client.get('/cities')
    assert response.status_code == 200
    assert response.json()[0]['name'] == 'Amsterdam'

    asset = client.get('/assets/cities/berlin.svg')
    assert asset.status_code == 200
    assert asset.headers['content-type'].startswith('image/svg+xml')
