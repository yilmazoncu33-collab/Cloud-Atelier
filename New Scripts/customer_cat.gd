extends Node2D

signal arrived(cat_ref)
var target_booth = null # Kedinin gideceği kabin

func _ready():
	# İlk geldiğinde bir bak bakalım yer var mı
	var found = find_free_booth()
	
	# Eğer yer bulamadıysan, kabin boşalana kadar pusuda bekle
	if not found:
		GameData.booth_freed.connect(find_free_booth)
	

func find_free_booth():
	for booth in GameData.trial_booths:
		if !booth.is_occupied:
			target_booth = booth
			booth.is_occupied = true 
			# Eğer bekleyenler listesindeysek artık oradan çıkabiliriz (sinyal bağlantısını kes)
			if GameData.booth_freed.is_connected(find_free_booth):
				GameData.booth_freed.disconnect(find_free_booth)
			walk_to(target_booth.global_position)
			return true
	return false
	# Kabin bulamayan kediyi burada görüyoruz:
	print("KRİTİK: Kabinler dolu, kedi kapıda kaldı!")
	GameData.print_status_report()

func walk_to(target: Vector2):
	$AnimatedSprite2D.play("Walk")
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, 4.0)
	tween.finished.connect(func():
		$AnimatedSprite2D.stop()
		arrived.emit(self) # Sadece bu yetsin, alttakini sil
	)
	
func return_to_start():
	if target_booth: 
		target_booth.is_occupied = false
		target_booth.current_customer = null
		GameData.booth_freed.emit()
	$AnimatedSprite2D.play("Walk")
	$AnimatedSprite2D.flip_h = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(-100, 300), 4.0)
	tween.finished.connect(queue_free)

func walk_to_exit(target: Vector2):
	$AnimatedSprite2D.play("Walk")
	$AnimatedSprite2D.flip_h = true # Geri dönerken sola baksın
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, 4.0)
	
	# Ekran dışına çıkınca kediyi tamamen yok et (RAM şişmesin)
	tween.finished.connect(func():
		queue_free()
	)
