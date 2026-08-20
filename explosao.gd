extends Node2D

var quantidade := 20
var distancia := 600.0

func explosao():
	for i in quantidade:
		var bolinha = Sprite2D.new()
		
		# Cria uma imagem pequena para a bolinha
		var imagem = Image.create(4, 4, false, Image.FORMAT_RGBA8)
		imagem.fill(Color.WHITE)
		
		bolinha.texture = ImageTexture.create_from_image(imagem)
		bolinha.position = Vector2.ZERO
		
		add_child(bolinha)
		
		# Direção aleatória
		var direcao = Vector2.RIGHT.rotated(
			randf_range(0.0, TAU)
		)
		
		var destino = direcao * randf_range(30.0, distancia)
		
		var tween = create_tween()
		
		tween.tween_property(
			bolinha,
			"position",
			destino,
			0.3
		)
		
		tween.parallel().tween_property(
			bolinha,
			"modulate:a",
			0.0,
			0.3
		)
		
		tween.tween_callback(bolinha.queue_free)
	
	await get_tree().create_timer(0.35).timeout
	queue_free()
