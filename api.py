# -*- coding: utf-8 -*-

import os
from flask import Flask
from flask import request
from flask import Response
from urllib.parse import unquote
from threading import _start_new_thread
from werkzeug.routing import BaseConverter

def git_pull():
    os.system("cd /home/pi/tmaize-blog&&sudo git pull origin master")

class RegexConverter(BaseConverter):
    def __init__(self, map, *args):
        self.map = map
        self.regex = args[0]

app = Flask(__name__)
# 正则匹配路由
app.url_map.converters['regex'] = RegexConverter

@app.route("/webhook", methods=["POST"])
def webhook():
    if request.json:
        _start_new_thread(git_pull, ())
    return b'ok.'

@app.route('/_posts/<regex(".*"):url>')
def posts(url):
    filename = f"posts/{unquote(url)}"
    if not os.path.exists(filename):
        return b''
    with open(filename, "rb") as f:
        response = Response(f.read(), content_type="application/octet-stream")
        response.headers['Content-Disposition'] = f'attachment; filename={filename.split("/")[-1]}'.encode()
        response.headers['content-length'] = os.stat(filename).st_size
        return response

@app.route('/ip')
def get_ip():
    return request.remote_addr+'\n'


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=2222)
