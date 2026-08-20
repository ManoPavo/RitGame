extends Node2D

@export var centro := Vector2(0, -100)
@export var raio := 80.0
@export var duracao := 2.0
signal acabou

var angulo := 0.0

func _ready():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_method(mover_circular, 0.0, TAU, duracao)


func mover_circular(valor: float):
	angulo = valor
	
	position = centro + Vector2(
		cos(angulo),
		sin(angulo)
	) * raio
