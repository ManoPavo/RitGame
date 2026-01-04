extends CanvasLayer

@onready var tela_preta = $ColorRect

func _ready() -> void:
	tela_preta.position.x = -4000

func _process(_delta: float) -> void:
	if visible:
		var tween = create_tween()
		tween.tween_property(tela_preta, "position:x", 1100, 3)
		tween.tween_callback(_esconder_automatico)  # Esconde depois da animação
		set_process(false)  # Para de rodar o _process

func _esconder_automatico():
	visible = false
	tela_preta.position.x = -4000
	set_process(true)  # Reativa pro próximo "visible = true"
