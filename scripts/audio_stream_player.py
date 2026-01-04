import sys
import json
import numpy as np
import librosa

def detect_beats_fast(audio_path):
	 #1. Carrega só o necessário
	y, sr = librosa.load(audio_path, sr=22050, duration=300)  # Máx 5min
	
	# 2. Método HÍBRIDO para qualquer música
	# Combina 3 técnicas diferentes
	beats_method1, _ = librosa.beat.beat_track(y=y, sr=sr, units='time')
	beats_method2 = librosa.onset.onset_detect(
		y=y, sr=sr, 
		units='time',
		backtrack=False
	)
	
	# 3. FUSÃO inteligente das batidas
	all_beats = sorted(list(set(list(beats_method1) + list(beats_method2))))
	
	# 4. Remove batidas muito próximas (<100ms)
	final_beats = []
	for beat in all_beats:
		if not final_beats or (beat - final_beats[-1]) > 0.1:
			final_beats.append(float(beat))
	
	# 5. BPM médio
	if len(final_beats) > 1:
		avg_interval = np.mean(np.diff(final_beats))
		bpm = 60 / avg_interval if avg_interval > 0 else 120
	else:
		bpm = 120
	
	# 6. Retorna APENAS o necessário
	return {
		"beats": final_beats,
		"bpm": float(bpm),
		"count": len(final_beats),
		"duration": float(len(y) / sr)
	}

if __name__ == "__main__":
	if len(sys.argv) > 1:
		result = detect_beats_fast(sys.argv[1])
		print(json.dumps(result, separators=(',', ':')))
