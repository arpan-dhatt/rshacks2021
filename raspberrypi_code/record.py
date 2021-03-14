import pyaudio
import wave
import uuid
import time

#from pixel_ring import pixel_ring


class Recorder:
    def __init__(self):
        self.CHUNK = 1024
        self.FORMAT = pyaudio.paInt16
        self.CHANNELS = 1
        self.RATE = 44100
        self.RECORD_SECONDS = 1
        self.uid = str(uuid.uuid4().hex[:8])
        self.WAVE_OUTPUT_FILENAME = f"speech_commands_v0.02/tmp/{self.uid}.wav"
        self.p = pyaudio.PyAudio()
        self.stream = None
        self.frames = []
        #self.power = LED(5)
        #self.power.on()
        #pixel_ring.pixel_ring.set_brightness(100)

    def ready(self):
        #pixel_ring.pixel_ring.speak()
        self.stream = self.p.open(format=self.FORMAT,
                                  channels=self.CHANNELS,
                                  rate=self.RATE,
                                  input=True,
                                  frames_per_buffer=self.CHUNK,
                                  input_device_index=0)

    def record(self):
        print("***Recording***")
        for i in range(0, int(self.RATE / self.CHUNK * self.RECORD_SECONDS)):
            data = self.stream.read(self.CHUNK)
            self.frames.append(data)
        self.stream.stop_stream()
        self.stream.close()
        self.p.terminate()
        #pixel_ring.pixel_ring.off()
        #self.power.off()

        wf = wave.open(self.WAVE_OUTPUT_FILENAME, 'wb')
        wf.setnchannels(self.CHANNELS)
        wf.setsampwidth(self.p.get_sample_size(self.FORMAT))
        wf.setframerate(self.RATE)
        wf.writeframes(b''.join(self.frames))
        wf.close()
        return self.uid


if __name__ == '__main__':
    r = Recorder()
    r.ready()
    print(r.record())
