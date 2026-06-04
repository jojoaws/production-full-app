from flask import Flask, request, jsonify
import boto3
import os
import uuid

app = Flask(__name__)

dynamodb = boto3.resource(
    "dynamodb",
    region_name=os.environ["AWS_REGION"]
)

table = dynamodb.Table(os.environ["USERS_TABLE"])

s3 = boto3.client("s3")

BUCKET_NAME = os.environ["UPLOAD_BUCKET"]

@app.route("/users", methods=["POST"])
def create_user():

    data = request.json

    user = {
        "user_id": str(uuid.uuid4()),
        "name": data["name"],
        "email": data["email"]
    }

    table.put_item(Item=user)

    return jsonify(user), 201


@app.route("/users/<user_id>", methods=["GET"])
def get_user(user_id):

    response = table.get_item(
        Key={
            "user_id": user_id
        }
    )

    return jsonify(response.get("Item", {}))


@app.route("/upload", methods=["POST"])
def upload_file():

    file = request.files["file"]

    s3.upload_fileobj(
        file,
        BUCKET_NAME,
        file.filename
    )

    return {
        "message": "uploaded"
    }

@app.route("/health", methods=["GET"])
def health():
    return {"status": "healthy"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

