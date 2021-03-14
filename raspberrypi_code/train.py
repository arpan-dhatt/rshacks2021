import glob
import os
import random
import numpy as np
from tensorflow import keras, lite, data, function, io, expand_dims, slice, squeeze, math, audio, size
import tensorflowjs as tfjs
from classifier.utils import resample_wavs, reset
from scipy.io import wavfile
from pixel_ring import pixel_ring

class Trainer:
    def __init__(self, sound_name, preprocessing_model_path="model/sc_preproc_model"):
        pixel_ring.pixel_ring.listen()
        self.preproc_model = keras.models.load_model(preprocessing_model_path)
        self.preproc_model.summary()
        self.TARGET_SAMPLE_RATE = 44100
        self.waveform_length = self.preproc_model.input_shape[-1]
        print(self.waveform_length)
        self.data_dir = "speech_commands_v0.02/"
        sound_name = 'knock'
        self.sounds = ("_background_noise_snippets_", sound_name)

        self.noise_wav_paths = glob.glob(os.path.join(self.data_dir, "_background_noise_", "*.wav"))
        self.knock_wav_paths = glob.glob(os.path.join(self.data_dir, "tmp", "*.wav"))

        self.snippets_dir = os.path.join(self.data_dir, "_background_noise_snippets_")
        os.makedirs(self.snippets_dir, exist_ok=True)

        for noise_wav_path in self.noise_wav_paths:
            print("Extracting snippets from %s..." % noise_wav_path)
            self.extract_snippets(noise_wav_path, snippet_duration_sec=1.0)
        self.snippets_dir = os.path.join(self.data_dir, sound_name)
        for kwp in self.knock_wav_paths:
            print("Extracting snippets from %s..." % kwp)
            self.extract_snippets(kwp, snippet_duration_sec=1.0)

    def extract_snippets(self, wav_path, snippet_duration_sec=1.0):
        basename = os.path.basename(os.path.splitext(wav_path)[0])
        sample_rate, xs = wavfile.read(wav_path)
        assert xs.dtype == np.int16
        n_samples_per_snippet = int(snippet_duration_sec * sample_rate)
        i = 0
        while i + n_samples_per_snippet < len(xs):
            snippet_wav_path = os.path.join(self.snippets_dir, "%s_%.5d.wav" % (basename, i))
            snippet = xs[i: i + n_samples_per_snippet].astype(np.int16)
            wavfile.write(snippet_wav_path, sample_rate, snippet)
            i += n_samples_per_snippet

    def pre_process_data(self):
        reset(self.data_dir, self.sounds)
        self.xs, self.ys = None, None
        for sound in self.sounds:
            word_dir = os.path.join(self.data_dir, sound)
            print(word_dir)
            assert os.path.isdir(word_dir)
            resample_wavs(word_dir, target_sample_rate=self.TARGET_SAMPLE_RATE)
        input_wav_paths_and_labels = self.retrieve_labels_and_paths()

        input_wav_paths, labels = ([t[0] for t in input_wav_paths_and_labels],
                                   [t[1] for t in input_wav_paths_and_labels])
        dataset = self.get_dataset(input_wav_paths, labels)

        xs_and_ys = list(dataset)
        self.xs = np.stack([item[0] for item in xs_and_ys])
        self.ys = np.stack([item[1] for item in xs_and_ys])
        print("Done.")

    def train(self):
        model_json = "model/model.json"
        orig_model = tfjs.converters.load_keras_model(model_json, load_weights=True)

        model = keras.Sequential(name="TransferLearnedModel")
        for layer in orig_model.layers[:-1]:
            model.add(layer)
        model.add(keras.layers.Dense(units=len(self.sounds), activation="softmax"))

        for layer in model.layers[:-1]:
            layer.trainable = False

        model.compile(optimizer="nadam", loss="sparse_categorical_crossentropy", metrics=["acc"])
        model.fit(self.xs, self.ys, batch_size=8, validation_split=0.3, shuffle=True, epochs=30)

        combined_model = keras.Sequential(name='CombinedModel')
        combined_model.add(self.preproc_model)
        combined_model.add(model)
        combined_model.build([None, self.waveform_length])
        combined_model.summary()

        tflite_output_path = 'model/combined_model.tflite'
        converter = lite.TFLiteConverter.from_keras_model(combined_model)
        converter.target_spec.supported_ops = [
            lite.OpsSet.TFLITE_BUILTINS, lite.OpsSet.SELECT_TF_OPS
        ]
        converter.experimental_new_converter = True
        pixel_ring.pixel_ring.off()
        print("OK")
        #contents = converter.convert()
        print("Saving tflite file at: %s" % tflite_output_path)
        #with open(tflite_output_path, 'wb') as f:
        #    f.write(contents)
        # pixel_ring.pixel_ring.off()
        # self.power.off()

    def retrieve_labels_and_paths(self):
        input_wav_paths_and_labels = []
        for i, sound in enumerate(self.sounds):
            wav_paths = glob.glob(os.path.join(self.data_dir, sound, "*_%shz.wav" % self.TARGET_SAMPLE_RATE))
            print("Found %d examples for class %s" % (len(wav_paths), sound))
            labels = [i] * len(wav_paths)
            input_wav_paths_and_labels.extend(zip(wav_paths, labels))
        random.shuffle(input_wav_paths_and_labels)
        return input_wav_paths_and_labels

    @function
    def read_wav(self, filepath):
        file_contents = io.read_file(filepath)
        return expand_dims(squeeze(audio.decode_wav(
            file_contents,
            desired_channels=-1,
            desired_samples=self.TARGET_SAMPLE_RATE).audio, axis=-1), 0)

    @function
    def filter_by_waveform_length(self, waveform, label):
        return size(waveform) > self.waveform_length

    @function
    def crop_and_convert_to_spectrogram(self, waveform, label):
        cropped = slice(waveform, begin=[0, 0], size=[1, self.waveform_length])
        return squeeze(self.preproc_model(cropped), axis=0), label

    @function
    def spectrogram_elements_finite(self, spectrogram, label):
        return math.reduce_all(math.is_finite(spectrogram))

    def get_dataset(self, input_wav_paths, labels):

        ds = data.Dataset.from_tensor_slices(input_wav_paths)
        ds = ds.map(self.read_wav)
        ds = data.Dataset.zip((ds, data.Dataset.from_tensor_slices(labels)))
        ds = ds.filter(self.filter_by_waveform_length)
        ds = ds.map(self.crop_and_convert_to_spectrogram)
        ds = ds.filter(self.spectrogram_elements_finite)
        return ds


if __name__ == '__main__':
    trainer = Trainer("knock")
    trainer.pre_process_data()
    trainer.train()
