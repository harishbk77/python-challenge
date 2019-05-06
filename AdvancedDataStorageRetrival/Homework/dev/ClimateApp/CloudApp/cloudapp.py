import sqlalchemy
import pandas as pd
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, jsonify, render_template, url_for, g

engine = create_engine("sqlite:///../../../Resources/hawaii.sqlite")

app = Flask(__name__)

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

query = "SELECT date, prcp FROM measurement where date > date((SELECT MAX(date) FROM measurement),'-12 month')"

# Save the query results as a Pandas DataFrame and set the index to the date column
weather_df = pd.read_sql_query(query, engine)
weather_df.set_index = ('date')

# Sort the dataframe by date
weather_df.sort_values(by=['date'])

html= weather_df.to_html()
json = weather_df.to_json()


#---- LIST OF STATION ----
query2 = "select * from station"

# Save the query results as a Pandas DataFrame and set the index to the date column
station_df = pd.read_sql_query(query2, engine)

json2 = station_df.to_json()


#----- TOBS -----

query6 = "SELECT tobs FROM measurement where date > date((SELECT MAX(date) FROM measurement),'-12 month')" 
temp_df = pd.read_sql_query(query6, engine)
json3 = temp_df.to_json()

@app.route("/")
def home():
    return html

@app.route("/api/v1.0/precipitation")
def normal():
    return json

@app.route("/api/v1.0/stations")
def jsonified():
    return json2

@app.route("/api/v1.0/tobs")
def jsonified2():
    return json3

@app.route('/')
@app.route('/index')
def index():
	return render_template('index.html')

if __name__ == "__main__":
	app.run(debug=True)