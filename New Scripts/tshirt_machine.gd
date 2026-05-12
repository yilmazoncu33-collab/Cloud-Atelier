extends Node2D

signal production_finished

@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func start_machine() -> void:
	print("Machine started working...")
	anim_sprite.play("Work")
	timer.start()

func _on_timeout() -> void:
	anim_sprite.stop()
	print_debug("Tshirt Produced, Machine Stopped.")
	production_finished.emit()
