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
	add_child(cat)
	
	# HATA BURADAYDI: Başına 'GameData.' eklemezsen tanımaz.
	GameData.incoming_cats.append(cat) 
	
	cat.arrived.connect(_on_cat_arrived)
	GameData.print_status_report()

func _on_cat_arrived(cat_ref):
	# Burada da başına 'GameData.' ekle:
	if cat_ref in GameData.incoming_cats:
		GameData.incoming_cats.erase(cat_ref)
	
	GameData.waiting_cats.append(cat_ref)
	GameData.new_cat_ready.emit()
	GameData.print_status_report()
	
