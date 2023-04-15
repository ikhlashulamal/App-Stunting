import numpy as np
from flask import Flask, flash, redirect, url_for, request, jsonify, render_template
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

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
UPLOAD_FOLDER = 'static/uploads/'

# Create flask app
flask_app = Flask(__name__)
flask_app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///vastunting.db"
flask_app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
flask_app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
db = SQLAlchemy()
db.init_app(flask_app)
modeldiagnosa = pickle.load(open("modeldiagnosa_svm.pkl", "rb"))
modelgizi = pickle.load(open("model_gizi.pkl", "rb"))

class log_activity(db.Model):
    __tablename__ = 'Log_History'
    id = db.Column(db.Integer, primary_key=True)
    tanggal = db.Column(db.String, nullable=False, default=datetime.datetime.now())
    aktivitas = db.Column(db.String, nullable=False)

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

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

@flask_app.route('/chatbotmobileapp', methods=["POST"])
def chatmobile():
    userText = request.json['pesan']
    # userText = [msg]
    tanggal = datetime.datetime.now()
    tanggal_baru = tanggal.strftime('%Y-%m-%d %H:%M:%S')
    data_log = log_activity(
        tanggal=tanggal_baru,
        aktivitas="User Bertanya ke Chatbot",
    )
    db.session.add(data_log)
    db.session.commit()
    return chatbot.chatbot_response(userText)

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
            tes = modelgizi.predict(gambar1_fix)
            if tes == 0:
                note = "mengalami gizi buruk"
            elif tes == 1:
                note = "Normal"
            else:
                note = "Tidak Dipahami"
            return render_template('upload.html', filename = filename, prediction_teks = "Anak anda {}".format(note))
    return render_template('upload.html')

@flask_app.route('/uploadmobile', methods=['GET', 'POST'])
def uploadfilemobile():
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
            tes = modelgizi.predict(gambar1_fix)
            if tes == 0:
                note = "mengalami gizi buruk"
            elif tes == 1:
                note = "Normal"
            else:
                note = "Tidak Dipahami"
            return "Anak anda {}".format(note)

@flask_app.route('/display/<filename>')
def display_image(filename):
	#print('display_image filename: ' + filename)
	return redirect(url_for('static', filename='uploads/' + filename), code=301)

if __name__ == "__main__":
    flask_app.run(debug=True)
    flask_app.run(host='192.168.43.170', port='5000', debug=True, threaded=False)