extends Node2D
signal missou

var speed = 500
@onready var caqui = $caqui

func _ready() -> void:
	await get_tree().process_frame
	
	if caqui != null:
		caqui.frame = 1
	
	var sprite = find_child("Sprite2D", true, false)
	if sprite == null:
		return
		
	if is_in_group("Esquerda"):
		sprite.flip_h = true
		sprite.rotation_degrees = 0
	elif is_in_group("Direita"):
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	elif is_in_group("Cima"):
		sprite.rotation_degrees = -90
	elif is_in_group("Baixo"):
		sprite.rotation_degrees = 90

func anima():
	if is_instance_valid(caqui):
		caqui.play("default")
		
		var tween = create_tween()
		tween.tween_property(caqui, "position:y", -50, 2)
		await caqui.animation_finished
		if is_instance_valid(self):
			queue_free()
	
func _process(delta) -> void:
	global_position.y += speed * delta
	
	
	if global_position.y > 650:
		var sprites = get_tree().get_nodes_in_group("Personagem")
		missou.emit()
		queue_free()
