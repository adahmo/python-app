from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "I LOVE K8S"

if __name__ == "__main__":
    # Listen on all interfaces, port 8005
    app.run(host="0.0.0.0", port=8005)
