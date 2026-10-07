from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(app="session17-devsecops", message="Hello from the DevSecOps pipeline!")


@app.route("/health")
def health():
    return jsonify(status="healthy")


@app.route("/api/greet/<name>")
def greet(name):
    return jsonify(message=f"Hello, {name}!")


@app.route("/api/add", methods=["POST"])
def add():
    data = request.get_json(silent=True) or {}
    if "a" not in data or "b" not in data:
        return jsonify(error="send both a and b"), 400
    return jsonify(result=data["a"] + data["b"])
