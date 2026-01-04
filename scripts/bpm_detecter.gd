extends Node2D

var detected_bpm = 0
var detected_beats = 0

func _ready():
	BpmDetecter.show()
	Music.stop_music()

func analyze_audio_with_python(audio_path: String):
	var output = []
	var executable_path = ""
	var args = []
	
	if OS.has_feature("editor"):
		# No editor, usamos o python instalado no sistema
		executable_path = "python"
		args = [ProjectSettings.globalize_path("res://bpm_detecter.py"), ProjectSettings.globalize_path(audio_path)]
	else:
		# No jogo exportado, usamos o executável gerado pelo PyInstaller
		# O executável deve estar na mesma pasta que o executável do jogo
		executable_path = OS.get_executable_path().get_base_dir().path_join("bpm_detecter.exe")
		args = [ProjectSettings.globalize_path(audio_path)]
	
	print("Executando: ", executable_path, " com argumentos: ", args)
	
	# Executar script Python
	var exit_code = OS.execute(executable_path, args, output, true, true)
	print("Exit code: ", exit_code)
	print("Output: ", output)
	
	if exit_code == 0:
		if output.size() > 0:
			var result = JSON.parse_string(output[0])
			if result != null:
				return result
			else:
				print("Erro ao parsear: JSON inválido")
		else:
			print("Erro: Saída vazia do executável")
	else:
		print("Erro ao executar Python: ", exit_code)


# Uso com FileDialog
func _on_button_pressed():
	$FileDialog.popup()

func _on_file_dialog_file_selected(path: String):
	var audio_stream = AudioStreamMP3.new()
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = file.get_buffer(file.get_length())
		audio_stream.data = data
		file.close()
		if audio_stream.get_length() <= 0:
			print("Erro: arquivo de áudio inválido: ", path)
			return
	else:
		print("Erro ao abrir arquivo: ", path)
		return
	Global.audio_stream = audio_stream
	var result = analyze_audio_with_python(path)
	
	if result and "bpm" in result:
		print("Análise concluída!")
		print("BPM: ", result["bpm"])
		print("Total de batidas: ", result["count"])
		
		# Armazenar em variáveis
		detected_bpm = result["bpm"]
		detected_beats = result["count"]
		Global.bpm = result["bpm"]
		# Atualizar sua interface aqui
		$BPM_Label.text = "BPM: " + str(result["bpm"])
		$Beats_Label.text = "Batidas: " + str(result["count"])
		$AudioStreamPlayer.stream = audio_stream
		$AudioStreamPlayer.play()
		TrocarCena()
	elif result and "error" in result:
		print("Erro na análise: ", result["error"])
	else:
		print("Resultado inválido ou erro desconhecido")


func TrocarCena():
	get_tree().change_scene_to_file("res://scenes/modo_d.tscn")
