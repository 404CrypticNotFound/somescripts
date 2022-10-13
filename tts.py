# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
from pygame import mixer, _sdl2 as devices
import time
import pyttsx3
import json
import urllib
import os
import random
engine = pyttsx3.init()

hostName = "localhost"
serverPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        #if self.path != "/favicon.ico":
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(bytes(json.dumps({'received': 'ok'}), "utf-8"))
        print("lalalalala")
        num = str(random.randrange(1,1000000))
        print(num)
        query = urllib.parse.urlparse(self.path).query
        print("1")
        query_components = dict(qc.split("=") for qc in query.split("&"))
        print("2")
        if "%20" in query_components["text"]:
            engine.save_to_file(query_components["text"].replace('%20', ' '), "C:/Users/splat/Desktop/scripts/"+num + '.wav')
        elif "+" in query_components['text']:
            engine.save_to_file(query_components["text"].replace('+', ' '), "C:/Users/splat/Desktop/scripts/"+num + '.wav')
        else:
            engine.save_to_file(query_components["text"].replace('%20', ' '), "C:/Users/splat/Desktop/scripts/"+num + '.wav')
        print(self.path.replace('%20', ' ')[1:])
        engine.runAndWait()
        mixer.init(devicename = "CABLE Input (VB-Audio Virtual Cable)")
        mixer.music.load("C:/Users/splat/Desktop/scripts/" + num + ".wav")
        mixer.music.play()
        a = mixer.Sound(num + ".wav")
        time.sleep(a.get_length())
        mixer.music.unload()
        os.remove(num + ".wav")
        #else:
            #self.send_response(400)

if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
