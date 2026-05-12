extends Node2D
var customercat_scene = preload("res://New Scenes/customer_cat.tscn")
@onready var tshirt_machine = get_node("../Atelier/TshirtMachine")

func _ready() -> void:
	spawn_timer()

func spawn_timer():
	await get_tree().create_timer(randf_range(5.0, 10.0)).timeout
	create_customercat()

func create_customercat():
	var cat = customercat_scene.instantiate()
	cat.position = Vector2(-50, 300) 
	add_child(cat)
	
	# 1. BAĞLANTI: Kedi gelince makine başlasın
	cat.arrived.connect(tshirt_machine.start_machine)
	
	# 2. BAĞLANTI: Makine bitince BU kedi geri dönsün
	# (CONNECT_ONE_SHOT önemli; sadece bu kedi için bir kez çalışır)
	tshirt_machine.production_finished.connect(cat.return_to_start, CONNECT_ONE_SHOT)
