from app.main import app

client = app.test_client()


def test_health():
    assert client.get("/health").get_json() == {"status": "ok"}


def test_add_endpoint():
    assert client.get("/add/2/3").get_json() == {"result": 5}


def test_divide_by_zero_endpoint():
    assert client.get("/divide/1/0").status_code == 400


def test_unknown_op():
    assert client.get("/power/2/3").status_code == 404
