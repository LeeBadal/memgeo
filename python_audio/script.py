from flask import Flask, send_from_directory
app = Flask(__name__)

@app.route('/audio/<path:filename>')
def serve_audio(filename):
    return send_from_directory("audio", filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
