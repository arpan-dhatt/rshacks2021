import glob
import tqdm
import numpy as np
import librosa
import os
from scipy.io import wavfile


def resample_wavs(dir_path, target_sample_rate=44100):
    wav_paths = glob.glob(os.path.join(dir_path, "*.wav"))
    resampled_suffix = "_%shz.wav" % target_sample_rate
    for i, wav_path in tqdm.tqdm(enumerate(wav_paths)):
        if wav_path.endswith(resampled_suffix):
            continue
        sample_rate, xs = wavfile.read(wav_path)
        xs = xs.astype(np.float32)
        xs = librosa.resample(xs, sample_rate, target_sample_rate).astype(np.int16)
        resampled_path = os.path.splitext(wav_path)[0] + resampled_suffix
        wavfile.write(resampled_path, target_sample_rate, xs)


def retreive_wav_paths(dir, sample_rate=44100):
    wav_paths = glob.glob(os.path.join(dir, "*_%shz.wav" % sample_rate))
    return wav_paths


def reset(dir, sounds: tuple):
    for sound in sounds:
        paths = retreive_wav_paths(os.path.join(dir, sound))
        for path in paths:
            try:
                os.remove(path)
            except:
                pass


