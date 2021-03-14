import os
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"

import time

import tensorflow as tf
from classifier.utils import resample_wavs, retreive_wav_paths


class Classifier:
    def __init__(self, preprocessing_model_path="model/sc_preproc_model"):
        self.preproc_model = tf.keras.models.load_model(preprocessing_model_path)
        self.waveform_length = 44032
        self.sample_rate = 44100

    @staticmethod
    def resample_wav(*args):
        return resample_wavs(*args)

    def classify(self, dir):
        #resample_wavs(dir)
        wav_paths = retreive_wav_paths(dir)
        ds = self.get_wav(wav_paths)
        return ds

    def get_wav(self, input_wav_paths):
        file_contents = tf.io.read_file(input_wav_paths[0])
        waveform = tf.expand_dims(tf.squeeze(tf.audio.decode_wav(
            file_contents,
            desired_channels=-1,
            desired_samples=self.sample_rate).audio, axis=-1), 0)
        cropped = tf.slice(waveform, begin=[0, 0], size=[1, self.waveform_length])
        return cropped


if __name__ == '__main__':
    t_0 = time.time()
    c = Classifier()
    ds = c.get_wav(["files/voice.wav"])
    interpreter = tf.lite.Interpreter(model_path="model/combined_model.tflite")
    interpreter.allocate_tensors()
    print(tf.math.reduce_max(ds))
    # Get input and output tensors.
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    # Test the model on random input data.
    interpreter.set_tensor(input_details[0]['index'], ds)
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])
    print(time.time() - t_0)
    print(output_data)