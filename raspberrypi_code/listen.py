# https://arxiv.org/pdf/1612.09089.pdf
import pyaudio
import wave
import time
import logging
import tensorflow as tf
from collections import deque
from classifier.classifier import Classifier
from datetime import datetime
from pixel_ring import pixel_ring
from gpiozero import LED

power = LED(5)
pixel_ring.pixel_ring.set_brightness(100)
power.on()
with open("id/ID.txt", "r") as f:
    DEVICE_ID = f.readline()
import uuid
import requests, json

logging.basicConfig(filename="events.log",
                    filemode='a',
                    format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
                    datefmt='%H:%M:%S',
                    level=logging.DEBUG)


class Listener:
    def __init__(self):
        self.CHUNK = 1024
        self.FORMAT = pyaudio.paInt16
        self.CHANNELS = 1
        self.RATE = 44100
        self.RECORD_SECONDS = 1
        self.WAVE_OUTPUT_FILENAME = f"files/current/voice.wav"
        self.p = pyaudio.PyAudio()
        self.frames = deque([])
        self.c = Classifier()
        self.stream = None
        self.interpreter = tf.lite.Interpreter(model_path="model/combined_model.tflite")
        self.interpreter.allocate_tensors()
        self.input_details = self.interpreter.get_input_details()
        self.output_details = self.interpreter.get_output_details()


    def ready(self):
        print("***Recording***")
        self.stream = self.p.open(format=self.FORMAT,
                                  channels=self.CHANNELS,
                                  rate=self.RATE,
                                  input=True,
                                  frames_per_buffer=self.CHUNK,
                                  input_device_index=0)

    def process(self):
        self.write(self.WAVE_OUTPUT_FILENAME)
        ds = self.c.get_wav([self.WAVE_OUTPUT_FILENAME])
        self.interpreter.set_tensor(self.input_details[0]['index'], ds)
        self.interpreter.invoke()
        output_data = self.interpreter.get_tensor(self.output_details[0]['index'])
        if output_data[0][1] > .995:
            pixel_ring.pixel_ring.listen()
            logging.info("SOUND DETECTED")
            print(f"SOUND DETECTED! Confidence{output_data[0][1]}")
            now = datetime.now()
            now = now.replace(microsecond=0)
            self.write(f"files/detected/{str(now)}.wav")
            pixel_ring.pixel_ring.off()

            self.report(f"files/detected/{str(now)}.wav")
        self.frames.popleft()

    def write(self, filename):
        wf = wave.open(filename, 'wb')
        wf.setnchannels(self.CHANNELS)
        wf.setsampwidth(self.p.get_sample_size(self.FORMAT))
        wf.setframerate(self.RATE)
        wf.writeframes(b''.join(list(self.frames)))
        wf.close()

    def listen(self):
        data = self.stream.read(self.CHUNK, exception_on_overflow=False)
        self.frames.append(data)
        if len(self.frames) == (44032 / self.CHUNK):
            self.process()

    def report(self, filename):
        response = {"id": str(uuid.uuid4()),
                    "name": "Knock",
                    "device_id": str(DEVICE_ID),
                    "device_name": "Pi",
                    "category": "SmartHome",
                    "waveform": [""],
                    "wav": str(filename)
                    }
        response = json.dumps(response)
        print("REPORTED...")
        requests.post("http://47.37.119.216:8000/report", data=response)


if __name__ == '__main__':
    listener = Listener()
    listener.ready()
    while True:
        listener.listen()