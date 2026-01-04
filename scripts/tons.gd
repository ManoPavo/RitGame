extends AudioStreamPlayer

var playback: AudioStreamGeneratorPlayback
var phase := 0.0
var sample_rate := 44100.0

# Escala Lo-fi
var scale = [220.0, 246.94, 261.63, 293.66, 329.63]
var current_note := 0

# Envelope
var amplitude := 0.0
var target_amplitude := 0.22
var release_speed := 0.015

# Controle
var is_playing := false
var note_duration := 0.6
var note_timer := 0.0

# Lofi FX
var detune := 0.0
var wobble_phase := 0.0
var lowpass := 0.0

# Delay (eco)
var delay_buffer := []
var delay_index := 0
var delay_size := 22050  # ~0.5s

func _ready():
	delay_buffer.resize(delay_size)
	for i in delay_buffer.size():
		delay_buffer[i] = 0.0


func play_note():
	if not playing:
		play()
		await get_tree().process_frame
		playback = get_stream_playback()

	current_note = randi() % scale.size()
	detune = randf_range(-1.5, 1.5)
	amplitude = 0.0
	note_timer = 0.0
	is_playing = true


func _process(delta):
	if not is_playing or playback == null:
		return

	note_timer += delta
	if note_timer >= note_duration:
		is_playing = false

	# Envelope suave
	amplitude = lerp(amplitude, target_amplitude, 0.03)

	# wobble lento
	wobble_phase += delta * 0.5
	var wobble = sin(wobble_phase) * 1.5

	var frames = playback.get_frames_available()
	for i in range(frames):
		var freq = scale[current_note] + detune + wobble
		var raw = sin(phase * TAU)
		phase += freq / sample_rate

		# Filtro low-pass simples
		lowpass = lerp(lowpass, raw, 0.08)

		# Delay
		var delayed = delay_buffer[delay_index]
		delay_buffer[delay_index] = lowpass

		delay_index = (delay_index + 1) % delay_size

		var sample = (lowpass * 0.6 + delayed * 0.4) * amplitude
		playback.push_frame(Vector2(sample, sample))
