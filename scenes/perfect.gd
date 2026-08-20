extends Label

func _ready():

	# ===== APARÊNCIA =====

	# Cor principal
	add_theme_color_override("font_color", Color(1, 0.9, 0.2))

	# Contorno grosso
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", 10)

	# Sombra
	add_theme_color_override(
		"font_shadow_color",
		Color(0,0,0,0.6)
	)

	add_theme_constant_override("shadow_offset_x", 4)
	add_theme_constant_override("shadow_offset_y", 4)

	# Tamanho fonte
	add_theme_font_size_override(
		"font_size",
		52
	)

	# ===== ANIMAÇÃO =====

	scale = Vector2(0.3,0.3)
	modulate.a = 0.0

	rotation_degrees = randf_range(-8,8)

	global_position = Vector2(800,150)

	var tween=create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.1
	)

	tween.tween_property(
		self,
		"scale",
		Vector2(1.3,1.3),
		0.15
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)

	await tween.finished


	var t2=create_tween()
	t2.set_parallel(true)

	t2.tween_property(
		self,
		"scale",
		Vector2(1,1),
		0.1
	)

	t2.tween_property(
		self,
		"position:y",
		position.y-70,
		0.6
	)

	t2.tween_property(
		self,
		"rotation_degrees",
		rotation_degrees+
		randf_range(-10,10),
		0.6
	)

	await get_tree().create_timer(0.35).timeout


	var t3=create_tween()
	t3.set_parallel(true)

	t3.tween_property(
		self,
		"scale",
		Vector2(0.5,0.5),
		0.25
	)

	t3.tween_property(
		self,
		"modulate:a",
		0.0,
		0.25
	)

	await t3.finished
	queue_free()
