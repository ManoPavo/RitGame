extends MarginContainer

@onready var label: Label = $MarginContainer/Label

var velocidade_letras: float = 0.05
var intervalo_dialogo: float = 20.0
var tempo_na_tela: float = 2.0
var posicao_dialogo := Vector2(150, 350)
var dialogos = [
	"Olá!",
	"Você está aí?",
	"Que lugar estranho...",
	"Eu não lembro de ter vindo aqui.",
	"Será que tem alguém por perto?",
	"Isso está ficando estranho",
	"Eu acho que ouvi alguma coisa",
	"Melhor continuar andando",
	"Você também está ouvindo isso?",
	"Não olhe para trás"
]

var dialogos_disponiveis = []

func _ready() -> void:
	position = posicao_dialogo
	pivot_offset = size / 2
	scale = Vector2.ZERO
	dialogos_disponiveis = dialogos.duplicate()
	mostrar_dialogo_aleatorio()
	iniciar_dialogos()
	

func iniciar_dialogos() -> void:
	while true:
		await get_tree().create_timer(intervalo_dialogo).timeout
		mostrar_dialogo_aleatorio()

func mostrar_dialogo_aleatorio() -> void:
	if dialogos_disponiveis.is_empty():
		dialogos_disponiveis = dialogos.duplicate()

	var indice: int = randi_range(0, dialogos_disponiveis.size() - 1)
	var texto: String = dialogos_disponiveis[indice]

	dialogos_disponiveis.remove_at(indice)

	escrever_dialogo(texto)

func escrever_dialogo(texto: String) -> void:
	label.text = ""
	scale = Vector2.ZERO

	var tween_entrada = create_tween()
	tween_entrada.set_trans(Tween.TRANS_BACK)
	tween_entrada.set_ease(Tween.EASE_OUT)
	tween_entrada.tween_property(self, "scale", Vector2.ONE, 0.4)

	await tween_entrada.finished

	for letra in texto:
		label.text += letra
		await get_tree().create_timer(velocidade_letras).timeout

	await get_tree().create_timer(tempo_na_tela).timeout

	var tween_saida = create_tween()
	tween_saida.set_trans(Tween.TRANS_BACK)
	tween_saida.set_ease(Tween.EASE_IN)
	tween_saida.tween_property(self, "scale", Vector2.ZERO, 0.3)

	await tween_saida.finished

	label.text = ""
