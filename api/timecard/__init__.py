from flask import Flask, jsonify, Blueprint
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
app.config.from_object("timecard.config.Config")
db = SQLAlchemy(app)
CORS(app, resources={r"/*": {"origins": "*"}})
api_bp = Blueprint("api_bp", __name__)

class Timecard(db.Model):
    __tablename__ = "timecard"

    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.String(128), nullable=False)
    start = db.Column(db.String(128), nullable=False)
    end = db.Column(db.String(128), nullable=False)
    rest = db.Column(db.String(128), nullable=False)
    note = db.Column(db.String(256), nullable=True)

    def __init__(self, *args, **kwargs):
        super(Timecard, self).__init__(*args, **kwargs)

@api_bp.route("/cards")
def cards():
    timecards = Timecard.query.all()
    response_object = make_response(timecards)
    return jsonify(response_object), 200

def make_response(timecards):
    card_list = []
    for card in timecards:
        card_object = {
            'id': card.id,
            'date': card.date,
            'start': card.start,
            'end': card.end,
            'rest': card.rest,
            'note': card.note
        }
        card_list.append(card_object)
    response_object = {
        'data': {
            'timecard': card_list
        }
    }
    return response_object

app.register_blueprint(api_bp, url_prefix="/api")