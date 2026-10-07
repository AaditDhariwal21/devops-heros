import logging
import random
import time

from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("app")

app = Flask(__name__)

REQUESTS = Counter("app_requests_total", "total requests", ["path", "status"])
LATENCY = Histogram("app_request_seconds", "request time", ["path"])


@app.route("/")
def home():
    with LATENCY.labels("/").time():
        time.sleep(random.uniform(0.01, 0.2))  # pretend to do some work
    REQUESTS.labels("/", "200").inc()
    log.info("GET / 200")
    return jsonify(message="session20 monitoring demo")


@app.route("/error")
def error():
    REQUESTS.labels("/error", "500").inc()
    log.error("GET /error 500 - something broke")
    return jsonify(error="something broke"), 500


@app.route("/health")
def health():
    return jsonify(status="healthy")


@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)  # nosec - inside a container
