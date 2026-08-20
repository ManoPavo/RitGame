extends Node2D

var per = preload("res://PerfectPopup.tscn")
var good = preload("res://GoodPopup.tscn")
var bad = preload("res://BadPopup.tscn")
var miss = preload("res://MissPopup.tscn")
var seta = preload("res://scenes/seta.tscn")
var dialogo = preload("res://dialogo.tscn")
var boss = preload("res://boss_1.tscn")
var local = [Vector2(450,-100), Vector2(520,-100), Vector2(600,-100), Vector2(670,-100)]
var lo_final = [Vector2(450,528), Vector2(520,528), Vector2(600,528), Vector2(670,528)]
var score = 0
var vida = 6
var perfect = 1000
var animando = false
var lim_distancia = 200
@onready var Personagem = $personagem
@onready var countdown_label = $CountdownLabel
enum {Idle, Feliz, dano}
var estado_atual = "Idle"
var gerar_timer: Timer


func _ready() -> void:
	var dia = dialogo.instantiate()
	add_child(dia)
	Personagem.add_to_group("Personagem")
	randomize()
	$cora.frame = 5
	var tween = create_tween()
	tween.tween_callback(func(): countdown_label.text = " 1"; countdown_label.modulate.a = 1.0)
	tween.tween_property(countdown_label, "modulate:a", 0.0, 0.3).set_delay(0.3)
	tween.tween_callback(func(): countdown_label.text = " 2"; countdown_label.modulate.a = 1.0)
	tween.tween_property(countdown_label, "modulate:a", 0.0, 0.3).set_delay(0.3)
	tween.tween_callback(func(): countdown_label.text = " 3"; countdown_label.modulate.a = 1.0)
	tween.tween_property(countdown_label, "modulate:a", 0.0, 0.3).set_delay(0.3)
	tween.tween_callback(func(): countdown_label.text = "Go!"; countdown_label.modulate.a = 1.0)
	tween.tween_property(countdown_label, "modulate:a", 0.0, 0.3).set_delay(0.3)
	tween.tween_callback(func(): countdown_label.hide();começarGame())
	
	var bos = boss.instantiate()
	add_child(bos)
func começarGame():
	# Contagem de 1 até 3 usando tween
	
	
	gerar_timer = Timer.new()
	gerar_timer.wait_time = 0.5
	gerar_timer.one_shot = false
	gerar_timer.timeout.connect(gerar_cordenada)
	add_child(gerar_timer)
	gerar_timer.start()
	print("BPM usado: ", Global.bpm)
	
	if Global.audio_stream:
		var player = AudioStreamPlayer.new()
		player.stream = Global.audio_stream
		player.volume_db = -10.0
		add_child(player)
		player.finished.connect(func():
			player.play()
		)
		player.play()
		
	
	
func gerar_cordenada():
	var random = randi() % local.size()
	var spawn = seta.instantiate()
	spawn.position = local[random]
	if random==0:
		spawn.add_to_group("Esquerda")
	elif random == 1:
		spawn.add_to_group("Baixo")
	elif random == 2:
		spawn.add_to_group("Cima")
	elif random == 3:
		spawn.add_to_group("Direita")
	
	print(gerar_timer.wait_time)
	add_child(spawn)
	spawn.missou.connect(fazer_tween)
	
func apertar_tecla(number):
	if number == 0:
		var Esquerda = get_tree().get_nodes_in_group("Esquerda")
		if Esquerda.size() > 0:
			var mySeta = Esquerda[0]
			var distancia = mySeta.global_position.distance_to(lo_final[0])
			if distancia <= lim_distancia:
				
				troca_estado("Feliz")
				var tween = mySeta.create_tween()
				tween.tween_property(mySeta, "scale", Vector2(2, 2), 0.07)
				tween.tween_property(mySeta, "modulate:a", 0.0, 0.07)
				tween.tween_callback(func():
					if is_instance_valid(mySeta):
						mySeta.queue_free()
						)
				if distancia <= 50:
					score += perfect
					var p = per.instantiate()
					add_child(p)
					$BarraUlt.value -= 1
					print("Perfect")
				elif distancia <= 100:
					score += perfect / 5
					var g = good.instantiate()
					add_child(g)
					print("Médio")
				elif distancia <= 120:
					score += perfect / 3
					var b = bad.instantiate()
					add_child(b)
					print("Ruim")
				else:
					score -= 1000
					var m = miss.instantiate()
					add_child(m)
					print("Miss")

	if number == 1:
		var Baixo = get_tree().get_nodes_in_group("Baixo")
		if Baixo.size() > 0:
			var mySeta = Baixo[0]
			var distancia = mySeta.global_position.distance_to(lo_final[1])
			if distancia <= lim_distancia:
				
				troca_estado("Feliz")
				var tween = mySeta.create_tween()
				tween.tween_property(mySeta, "scale", Vector2(2, 2), 0.07) 
				tween.tween_property(mySeta, "modulate:a", 0.0, 0.07)      
				tween.tween_callback(mySeta.queue_free)
				if distancia <= 50:
					score += perfect
					var p = per.instantiate()
					add_child(p)
					print("Perfect")
				elif distancia <= 100:
					score += perfect /5
					var g = good.instantiate()
					add_child(g)
					print("MEDIO")
				elif distancia <= 120:
					score += perfect / 3
					var b = bad.instantiate()
					add_child(b)
					print("Ruim")
				else:
					score -= 1000
					var m = miss.instantiate()
					add_child(m)
					print("Miss")
	if number == 2:
		var Cima = get_tree().get_nodes_in_group("Cima")
		if Cima.size() > 0:
			var mySeta = Cima[0]
			var distancia = mySeta.global_position.distance_to(lo_final[2])
			if distancia <= lim_distancia:
				
				troca_estado("Feliz")
				var tween = mySeta.create_tween()
				tween.tween_property(mySeta, "scale", Vector2(2, 2), 0.07) 
				tween.tween_property(mySeta, "modulate:a", 0.0, 0.07)      
				tween.tween_callback(mySeta.queue_free)
				if distancia <= 50:
					score += perfect
					var p = per.instantiate()
					add_child(p)
					print("Perfect")
				elif distancia <= 100:
					score += perfect /5
					var g = good.instantiate()
					add_child(g)
					print("MEDIO")
				elif distancia <= 120:
					score += perfect / 3
					var b = bad.instantiate()
					add_child(b)
					print("Ruim")
				else:
					score -= 1000
					var m = miss.instantiate()
					add_child(m)
					print("Miss")
			

	if number == 3:
		var Direita = get_tree().get_nodes_in_group("Direita")
		if Direita.size() > 0:
			var mySeta = Direita[0]
			var distancia = mySeta.global_position.distance_to(lo_final[3])
			if distancia <= lim_distancia:
				
				troca_estado("Feliz")
				var tween = mySeta.create_tween()
				tween.tween_property(mySeta, "scale", Vector2(2, 2), 0.07) 
				tween.tween_property(mySeta, "modulate:a", 0.0, 0.07)      
				tween.tween_callback(mySeta.queue_free)
				if distancia <= 50:
					score += perfect
					var p = per.instantiate()
					add_child(p)
					print("Perfect")
				elif distancia <= 100:
					score += perfect /5
					var g = good.instantiate()
					add_child(g)
					print("MEDIO")
				elif distancia <= 120:
					score += perfect / 3
					var b = bad.instantiate()
					add_child(b)
					print("Ruim")
				else:
					score -= 1000
					var m = miss.instantiate()
					add_child(m)
					print("Miss")
				
func _physics_process(delta: float) -> void:
	
	match estado_atual:
		"Idle":
			Personagem.texture = preload("res://assets/Personagem/garota_idle.png")
		"Feliz":
			Personagem.texture = preload("res://assets/Personagem/garota_happy.png")
		"dano":
			Personagem.texture = preload("res://assets/Personagem/garota_Braba.png")
	
func troca_estado(novo_estado):
	if novo_estado != estado_atual:
		estado_atual = novo_estado
func fazer_tween():
		troca_estado("dano")
		var tween = create_tween()
		var intensidade = 10.0 
		var duracao = 0.05
		tween.tween_property(Personagem, "position:x", 162 - intensidade, duracao)
		tween.tween_property(Personagem, "position:x", 162 - intensidade, duracao)
		tween.tween_property(Personagem, "position:x", 162 + intensidade / 2, duracao)
		tween.tween_property(Personagem, "position:x", 162, duracao)
		
		var tweenLife = create_tween()
		tweenLife.tween_property($cora, "scale", Vector2(1.5, 1.5), 0.07)
		tweenLife.tween_property($cora, "scale", Vector2(1, 1), 0.07)
		vida -=1 
		if vida == 6:
			$cora.frame = 5
		if vida == 5:
			$cora.frame = 4
		if vida == 4:
			$cora.frame = 3
		if vida == 3:
			$cora.frame = 2
		if vida == 2:
			$cora.frame = 1
		if vida == 1:
			$cora.frame = 0
		if vida == 0:
			pass
		



func _process(delta: float) -> void:
	
	if $BarraUlt.value <= 0 :
		criar_explosao(Vector2(550,200))
		
		
	
	if gerar_timer != null:
		gerar_timer.wait_time = 60.0 / Global.bpm
	
	if vida <= 0:
		
		get_tree().change_scene_to_file("res://scenes/death.tscn") 
	
	$score.text = str(score)
	
	if Input.is_action_just_pressed("Esquerda"):
		apertar_tecla(0)
	if Input.is_action_just_pressed("Direita"):
		apertar_tecla(3)
	if Input.is_action_just_pressed("Baixo"):
		apertar_tecla(1)
	if Input.is_action_just_pressed("Cima"):
		apertar_tecla(2)
		
	
var explosao_scene = preload("res://explosao.tscn")

func criar_explosao(posicao: Vector2):
	var explosao = explosao_scene.instantiate()
	add_child(explosao)
	explosao.position = posicao
	
	explosao.explosao()
	
	gerar_timer.stop()
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 3.0)
	
