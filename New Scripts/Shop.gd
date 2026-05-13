extends Node2D

var customercat_scene = preload("res://New Scenes/customer_cat.tscn")

func _ready() -> void:
	GameData.request_boost_spawns.connect(spawn_multiple_cats)
	spawn_timer()

func spawn_multiple_cats():
	for i in range(randi_range(2,3)):
		create_customercat()
		# Kediler üst üste binmesin diye çok küçük bir bekleme (opsiyonel)
		await get_tree().create_timer(0.2).timeout

func spawn_timer():
	# Burası artık hep standart hızda (5-10 saniye) çalışacak
	await get_tree().create_timer(randf_range(5.0, 10.0)).timeout
	create_customercat()
	spawn_timer() # Döngü devam etsin

func create_customercat():
	var cat = customercat_scene.instantiate()
	cat.position = Vector2(-50, 300) 
	add_child(cat)
	
	# Kedi vardığında çalışacak fonksiyonu bağlıyoruz
	cat.arrived.connect(_on_cat_arrived)

func _on_cat_arrived(cat_ref):
	# Kediyi ortak listeye ekle ve zili çal
	GameData.waiting_cats.append(cat_ref)
	GameData.new_cat_arrived.emit()
	
