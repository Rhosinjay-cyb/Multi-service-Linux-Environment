from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "service": "webapp",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({
        "service": "webapp",
        "status": "healthy"
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=3000)
