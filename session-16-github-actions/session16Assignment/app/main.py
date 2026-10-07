from flask import Flask, jsonify

from app.calculator import add, subtract, multiply, divide

app = Flask(__name__)

OPS = {"add": add, "subtract": subtract, "multiply": multiply, "divide": divide}


@app.route("/")
def home():
    return jsonify(message="Session 16 calculator API", ops=list(OPS))


@app.route("/health")
def health():
    return jsonify(status="ok")


@app.route("/<op>/<int:a>/<int:b>")
def calculate(op, a, b):
    if op not in OPS:
        return jsonify(error="unknown op"), 404
    try:
        return jsonify(result=OPS[op](a, b))
    except ValueError as e:
        return jsonify(error=str(e)), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
