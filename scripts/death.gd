extends CanvasLayer

@onready var som = $AudioStreamPlayer

func _ready() -> void:
	$Gameover.modulate.a = 0
	self.visible = true
	


func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	if self.visible:
		tween.tween_property($ColorRect, "modulate:v", 0 , 0.15 )
		tween.tween_property($Gameover, "modulate:a", 2, 30 )
		await get_tree().create_timer(4).timeout
	else:
		tween.tween_property($ColorRect, "modulate:v", 100, 0.1)
	if Input.is_anything_pressed():
		Transicao.visible = true
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		Music.play_music()
		
		
