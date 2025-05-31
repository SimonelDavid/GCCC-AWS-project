from flask import Flask, request, jsonify, Response
import boto3, os, uuid
from datetime import datetime
from PIL import Image
import psycopg2

app = Flask(__name__)

# Env vars
S3_BUCKET = os.environ.get('S3_BUCKET')
DB_HOST = os.environ.get('DB_HOST')
DB_NAME = os.environ.get('DB_NAME')
DB_USER = os.environ.get('DB_USER')
DB_PASS = os.environ.get('DB_PASS')

conn = psycopg2.connect(
    host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASS
)
cursor = conn.cursor()

s3 = boto3.client('s3')

@app.route('/upload', methods=['POST'])
def upload():
    text = request.form['text']
    image = request.files['image']
    review_id = str(uuid.uuid4())

    original_key = f"original/{review_id}_{image.filename}"
    thumb_key = f"thumbnails/{review_id}_thumb.jpg"

    # Save image to temp file and resize
    temp_path = f"/tmp/{image.filename}"
    image.save(temp_path)

    # Upload original to S3
    s3.upload_file(temp_path, S3_BUCKET, original_key)

    # Resize and save thumbnail
    img = Image.open(temp_path)
    img.thumbnail((128, 128))
    thumb_path = f"/tmp/thumb_{image.filename}"
    img.save(thumb_path)
    s3.upload_file(thumb_path, S3_BUCKET, thumb_key)

    # Insert into DB
    cursor.execute(
        "INSERT INTO reviews (id, text, image_url, thumb_url, created_at) VALUES (%s, %s, %s, %s, %s)",
        (review_id, text, original_key, thumb_key, datetime.utcnow())
    )
    conn.commit()

    return jsonify({"message": "Success"}), 201

@app.route('/reviews', methods=['GET'])
def get_reviews():
    cursor.execute("SELECT id, text, image_url, thumb_url, created_at FROM reviews ORDER BY created_at DESC")
    rows = cursor.fetchall()
    return jsonify([
        {
            "id": str(row[0]),
            "text": row[1],
            "image_url": row[2],
            "thumb_url": row[3],
            "created_at": row[4].isoformat()
        } for row in rows
    ])

@app.route('/image', methods=['GET'])
def get_image():
    key = request.args.get("key")
    if not key:
        return jsonify({"error": "Missing key"}), 400
    try:
        s3_response = s3.get_object(Bucket=S3_BUCKET, Key=key)
        return Response(
            s3_response['Body'].read(),
            mimetype=s3_response['ContentType']
        )
    except Exception as e:
        return jsonify({'error': str(e)}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)