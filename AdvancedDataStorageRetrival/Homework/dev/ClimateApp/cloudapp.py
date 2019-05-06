from flask import Flask, render_template, url_for

@app.route('/')
app = Flask(__name__)

@app.route('/index')
def index():
	render_template('index.html')

if __name__ == "__main__":
	app.run()