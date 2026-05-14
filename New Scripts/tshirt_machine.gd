extends Node2D

var is_working: bool = false # Makine şu an meşgul mü?
var current_cat = null

@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _ready() -> void:
	$Timer.wait_time = 5.0
	$Timer.one_shot = true # Tek sefer çalışsın
	# KABLOYU KODLA BAĞLIYORUZ (Garanti yol)
	if !$Timer.timeout.is_connected(_on_timeout):
		$Timer.timeout.connect(_on_timeout)
	
	GameData.new_cat_ready.connect(check_queue)
	# Oyun başında kedi varsa hemen kontrol et
	check_queue()
	
func check_queue():
	# Makine boşsa VE sırada kedi varsa başla
	if !is_working and GameData.waiting_cats.size() > 0:
		is_working = true
		current_cat = GameData.waiting_cats.pop_front()
		
		# Hata testi için print koyalım
		print("Makine kedi aldi. Kalan sira: ", GameData.waiting_cats.size())
		
		$AnimatedSprite2D.play("Work")
		$Timer.start()
		GameData.print_status_report()

func start_machine():
	is_working = true
	# Sıradaki ilk kediyi kap (M/M/s kuyruk mantığı kanka)
	current_cat = GameData.waiting_cats.pop_front()
	
	anim_sprite.play("Work")
	timer.start()
	
	print("Machine started for a new customer...")
	anim_sprite.play("Work")
	timer.start()

func _on_timeout():
	print("5 saniye bitti, kedi gonderiliyor.")
	$AnimatedSprite2D.stop()
	if current_cat:
		current_cat.return_to_start()
		current_cat = null
	
	is_working = false # BURASI ÇOK ÖNEMLİ!
	GameData.total_coins += 10
	GameData.print_status_report()
	
	# BEKLEME YAPMA DEVAM ET: Sırada bekleyen 9 kedi varsa hemen birini al
	check_queue()

func get_active_machine_count() -> int:
	var count = 0
	# Ana sahnedeki (Main) tüm makineleri kontrol et
	for node in get_tree().get_nodes_in_group("machines"):
		if node.is_working:
			count += 1
	return count
