extends Node2D

var customercat_scene = preload("res://New Scenes/customer_cat.tscn")

func _ready() -> void:
	GameData.request_boost_spawns.connect(spawn_multiple_cats)
	spawn_timer()

func spawn_multiple_cats():
	var requested_cats = randi_range(2, 3) # Boost ile gelen kedi isteği
	
	for i in range(requested_cats):
		if GameData.get_total_cat_count() < GameData.get_max_capacity():
			create_customercat()
			# Kediler üst üste binmesin diye kısa bekleme
			await get_tree().create_timer(0.2).timeout
		else:
			print("KAPASİTE DOLU: Boost daha fazla kedi sokamıyor! (Max: ", GameData.get_max_capacity(), ")")
			break # Dükkan doldu, döngüden çık

func spawn_timer():
	await get_tree().create_timer(randf_range(5.0, 10.0)).timeout
	
	# Normal akışta da kapasiteyi kontrol et
	if GameData.get_total_cat_count() < GameData.get_max_capacity():
		create_customercat()
	else:
		print("DÜKKAN DOLU: Yeni kedi kapıdan döndü.")
	
	spawn_timer()

func create_customercat():
	# Burada artık ekstra kontrol yapmaya gerek yok, çağıran yerler kontrol ediyor
	var cat = customercat_scene.instantiate()
	add_child(cat)
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
	
