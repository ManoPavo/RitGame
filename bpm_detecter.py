import sys
import json
import librosa
import warnings

warnings.filterwarnings("ignore")

if len(sys.argv) != 2:
    print(json.dumps({"error": "Usage: python bpm_detecter.py <audio_path>"}))
    sys.exit(1)

audio_path = sys.argv[1]

try:
    y, sr = librosa.load(audio_path)
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)
    bpm = float(tempo)
    beat_count = len(beat_frames)
    result = {"bpm": bpm, "count": beat_count}
    print(json.dumps(result))
except Exception as e:
    print(json.dumps({"error": str(e)}))
    sys.exit(1)
