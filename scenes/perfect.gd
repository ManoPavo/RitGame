extends Control



func _ready():
	scale = Vector2(0.6, 0.6)
	modulate.a = 0.0
	self.global_position = Vector2(800, 150)


	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Aparecer
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)

	# Subir levemente
	tween.tween_property(self, "position:y", position.y - 40, 0.3)

	# Sumir
	tween.tween_interval(0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)

	tween.finished.connect(queue_free)
