import numpy as np
from flask import Flask, flash, redirect, url_for, request, jsonify, render_template
from flask import Flask, render_template, request, redirect, flash, session
from flask import Flask, render_template, Response

from flask_sqlalchemy import SQLAlchemy
import pickle
import joblib
import datetime
import chatbot
import json
import os
import urllib.request
from werkzeug.utils import secure_filename
from PIL import Image
import os
import time
import numpy as np
from glob import glob
import cv2

# import sentimen
# Pembuatan Dashboard
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

#Implementasi Model
import nltk
import re
import pickle
from sklearn.utils.multiclass import unique_labels
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.tokenize import TweetTokenizer

#DBMS
import pymysql


ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
UPLOAD_FOLDER = 'static/uploads/'

# Create flask app
flask_app = Flask(__name__)
flask_app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///vastunting.db"
flask_app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
flask_app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
# Tetapkan kunci rahasia untuk sesi
flask_app.secret_key = 'kunci_rahasia_anda_di_sini'  # Gantilah dengan kunci yang aman dan acak
db = SQLAlchemy()
db.init_app(flask_app)
modeldiagnosa = pickle.load(open("modeldiagnosa_svm.pkl", "rb"))
# modelgizi = pickle.load(open("modelgizi.pkl", "rb"))

class log_activity(db.Model):
    __tablename__ = 'Log_History'
    id = db.Column(db.Integer, primary_key=True)
    tanggal = db.Column(db.String, nullable=False, default=datetime.datetime.now())
    aktivitas = db.Column(db.String, nullable=False)

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# funtion sentimen analisis
def is_table_empty(table, host='localhost', user='root', password='', database='riview'):
    # Establish a connection to the MySQL database
    connection = pymysql.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Check if the table is empty
    query_check_empty = f"SELECT COUNT(*) FROM {table}"
    cursor.execute(query_check_empty)
    count_result = cursor.fetchone()[0]

    # Close the cursor and the database connection
    cursor.close()
    connection.close()

    return count_result == 0

#Implemnetasi Model dengan Data Baru
def read_mysql_table(table, host='localhost', user='root', password='', database='riview'):
    # Establish a connection to the MySQL database
    connection = pymysql.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    query = f"SELECT * FROM {table}"
    cursor.execute(query)
    result = cursor.fetchall()
    
    # Convert the result to a Pandas DataFrame
    df = pd.DataFrame(result)
    
    # Assign column names based on the cursor description
    df.columns = [column[0] for column in cursor.description]
    
    # Close the cursor and the database connection
    cursor.close()
    connection.close()
    
    return df

# Implementasi model, preprocessing, dan analisis sentimen seperti pada contoh sebelumnya
@flask_app.route('/sentimen', methods=['GET', 'POST'])
def dashboard():
    # Baca data dari MySQL atau CSV
    table_name = 'hasil_model'
    if is_table_empty(table_name):
        data = pd.read_csv('Data/hasil_model.csv')
    else:
        data = read_mysql_table(table_name)

    data = data[['review', 'label']]

    # Menghitung jumlah data dengan label positif, negatif, dan netral
    jumlah_positif = len(data[data['label'] == 1])
    jumlah_negatif = len(data[data['label'] == 0])
    jumlah_netral = len(data[data['label'] == -1])

    # Menyusun data untuk ditampilkan di chart
    labels = ['Positif (1)', 'Negatif (0)', 'Netral (-1)']
    jumlah_data = [jumlah_positif, jumlah_negatif, jumlah_netral]
    colors = ['green', 'red', 'gray']

    return render_template('sentimen.html', labels=labels, jumlah_data=jumlah_data, colors=colors)

# Indentasi untuk fungsi-fungsi berikutnya telah diperbaiki
def is_table_empty(table, host='localhost', user='root', password='', database='riview'):
    # Implementasi seperti yang Anda miliki
    pass

def save_review_to_database(review, host='localhost', user='root', password='', database='riview'):
    # Implementasi seperti yang Anda miliki
    pass

@flask_app.route('/review_form', methods=['GET'])
def review_form():
    return render_template('review_form.html')

@flask_app.route('/submit_review', methods=['POST'])
def submit_review():
    review_text = request.form['review']
    
    # Hubungkan ke database dan simpan ulasan
    save_review_to_database(review_text)
    
    # Lakukan commit perubahan ke database
    db.session.commit()

    return redirect('/sentimen')  # Redirect ke halaman sentimen setelah submit review


#endpoint untuk membuat database.
@flask_app.route('/database/create', methods=["GET"])
def createDatabase():
    with flask_app.app_context():
        db.create_all()
        return "Database Created Successfully!"

@flask_app.route('/')
def Home():
    return render_template("index.html")

@flask_app.route('/tentang')
def tentang():
    return render_template("tentang.html")

@flask_app.route('/chatbot')
def halchatbot():
    return render_template('chatbot.html')


@flask_app.route('/RealTime')
def RealTime():
    return render_template('RealTime.html')

cap = cv2.VideoCapture(0)
cap.set(3, 640)  # Lebar frame
cap.set(4, 480)  # Tinggi frame

def midpoint(ptA, ptB):
    return ((ptA[0] + ptB[0]) // 2, (ptA[1] + ptB[1]) // 2)

def object_detection():
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        lower_green = np.array([40, 40, 40])
        upper_green = np.array([80, 255, 255])
        mask = cv2.inRange(hsv, lower_green, upper_green)
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > 500:
                x, y, w, h = cv2.boundingRect(contour)
                cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
                object_height_cm = h * 2.54
                cv2.putText(frame, f'Height: {object_height_cm:.2f} cm', (x, y - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
                mid_top = midpoint((x, y), (x+w, y))
                cv2.circle(frame, mid_top, 5, (255, 0, 0), -1)

        ret, jpeg = cv2.imencode('.jpg', frame)
        frame = jpeg.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n\r\n')

@flask_app.route('/video_feed')
def video_feed():
    return Response(object_detection(), mimetype='multipart/x-mixed-replace; boundary=frame')


@flask_app.route('/get')
def chat():
    userText = request.args.get('msg')
    tanggal = datetime.datetime.now()
    tanggal_baru = tanggal.strftime('%Y-%m-%d %H:%M:%S')
    data_log = log_activity(
        tanggal=tanggal_baru,
        aktivitas="User Bertanya ke Chatbot",
    )
    db.session.add(data_log)
    db.session.commit()
    return chatbot.chatbot_response(userText)

@flask_app.route('/mobile_chat', methods=['POST'])
def mobile_chat():
    try:
        user_message = request.json['message']
        bot_response = chatbot.chatbot_response(user_message)
        return jsonify({'response': bot_response})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@flask_app.route("/log")
def logactivity():
    return render_template('log_activity.html', logaktiv = log_activity.query.order_by(log_activity.tanggal.desc()).limit(5).all())

@flask_app.route("/logmobile")
def logmobile():
    log_data = db.session.execute(db.select(log_activity.tanggal, log_activity.aktivitas)).all()
    if(log_data is None):
        return f"Tidak Ada Aktivitas!"
    else:
        data=[]
        for aktiv in log_data:
            data.append({
                'Tanggal': aktiv.tanggal,
                'Aktivitas': aktiv.aktivitas,
            })
        return data

@flask_app.route("/diagnosa")
def diagnosa():
    return render_template("diagnosis.html")

@flask_app.route("/predict", methods = ["POST"])
def predict():
    float_features = [float(x) for x in request.form.values()]
    features = [np.array(float_features)]
    prediction = modeldiagnosa.predict(features)
    tanggal = datetime.datetime.now()
    tanggal_baru = tanggal.strftime('%Y-%m-%d %H:%M:%S')
    data_log = log_activity(
        tanggal=tanggal_baru,
        aktivitas="User Melakukan Diagnosa",
    )
    db.session.add(data_log)
    db.session.commit()
    return render_template("diagnosis.html", prediction_text = "Anak anda {}".format(prediction[0]))

@flask_app.route("/diagnosa/predict", methods = ["GET", "POST"])
def predictmobile():
    umur = request.json['umur']
    tinggi = request.json['tinggi']
    float_features = [float(umur),float(tinggi)]
    features = [np.array(float_features)]
    prediction = modeldiagnosa.predict(features)
    tanggal = datetime.datetime.now()
    tanggal_baru = tanggal.strftime('%Y-%m-%d %H:%M:%S')
    data_log = log_activity(
        tanggal=tanggal_baru,
        aktivitas="User Melakukan Diagnosa",
    )
    db.session.add(data_log)
    db.session.commit()
    return "Anak anda {}".format(prediction[0])

@flask_app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(flask_app.config['UPLOAD_FOLDER'], filename))
            gambar1 = Image.open('static/uploads/' + filename)
            gambar1_fix = gambar1.resize((200, 200)) #seluruh langkah preprocessing dilakukan disini
            gambar1_fix = np.reshape(np.array(gambar1_fix).flatten(), (1,-1))
    #         tes = modelgizi.predict(gambar1_fix)
    #         if tes == 0:
    #             note = "Stunting"
    #         elif tes == 1:
    #             note = "Normal"
    #         else:
    #             note = "Tinggi"
    #         return render_template('upload.html', filename = filename, prediction_teks = "Anak anda {}".format(note))
    # return render_template('upload.html')

@flask_app.route('/display/<filename>')
def display_image(filename):
	#print('display_image filename: ' + filename)
	return redirect(url_for('static', filename='uploads/' + filename), code=301)

if __name__ == "__main__":
    flask_app.run(debug=True)
    flask_app.run(host='192.168.56.78', port=5000, debug=True)
