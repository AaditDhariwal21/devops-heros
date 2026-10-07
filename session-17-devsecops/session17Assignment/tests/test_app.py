from app.main import app

client = app.test_client()


def test_home():
    assert client.get("/").status_code == 200


def test_health():
    assert client.get("/health").get_json() == {"status": "healthy"}


def test_greet():
    assert client.get("/api/greet/Aadit").get_json()["message"] == "Hello, Aadit!"


def test_add():
    r = client.post("/api/add", json={"a": 10, "b": 20})
    assert r.get_json()["result"] == 30


def test_add_missing_field():
    assert client.post("/api/add", json={"a": 5}).status_code == 400
