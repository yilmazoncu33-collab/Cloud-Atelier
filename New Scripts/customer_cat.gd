extends Node2D

signal arrived(cat_ref)

var move_tween: Tween
var target_booth = null
var is_wandering: bool = false
var wander_range_min = Vector2(100, 100) 
var wander_range_max = Vector2(1052, 548)


func _ready():
	var found = find_free_booth()
	if not found:
		# Yer yoksa hemen gezinmeye başla
		start_wandering()
		# Kabin boşaldığında sinyali dinlemeye devam et
		GameData.booth_freed.connect(_on_booth_freed_signal)
	
func _on_booth_freed_signal():
	# Yer boşalınca gezinmeyi bırak ve kabine gitmeyi dene
	is_wandering = false
	find_free_booth()

func start_wandering():
	if target_booth != null: return # Zaten kabine gidiyorsa gezme
	
	is_wandering = true
	_wander_to_next_point()

func _wander_to_next_point():
	if not is_wandering: return
	
	# Rastgele bir hedef nokta seç
	var random_x = randf_range(wander_range_min.x, wander_range_max.x)
	var random_y = randf_range(wander_range_min.y, wander_range_max.y)
	var target_pos = Vector2(random_x, random_y)
	
	# Oraya yürü
	$AnimatedSprite2D.play("Walk")
	# Sağa mı sola mı bakacağını ayarla
	$AnimatedSprite2D.flip_h = target_pos.x < global_position.x
	
	var tween = create_tween()
	# Gezinme hızı biraz daha yavaş olsun (mesela 2 saniye)
	tween.tween_property(self, "global_position", target_pos, 2.0)
	
	# Oraya varınca biraz bekle (idling) ve sonra yeni nokta seç
	tween.finished.connect(func():
		if is_wandering:
			$AnimatedSprite2D.play("Idle")
			# 1-3 saniye arası rastgele bekle, sonra tekrar yürü
			await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
			_wander_to_next_point()
	)

func find_free_booth():
	for booth in GameData.trial_booths:
		if !booth.is_occupied:
			# Yer bulduk!
			is_wandering = false # Gezinmeyi durdur
			target_booth = booth
			booth.is_occupied = true
			
			# Sinyal bağlantısını temizle
			if GameData.booth_freed.is_connected(_on_booth_freed_signal):
				GameData.booth_freed.disconnect(_on_booth_freed_signal)
			
			walk_to(target_booth.global_position)
			return true
	print("KRİTİK: Kabinler dolu, kedi kapıda kaldı!")
	GameData.print_status_report()
	return false
	# Kabin bulamayan kediyi burada görüyoruz:
	

func walk_to(target_pos: Vector2):
	if move_tween:
		move_tween.kill()
	
	var speed = 150.0 
	var distance = global_position.distance_to(target_pos)
	var duration = distance / speed
	
	# Yola çıkarken yürüme başlasın
	$AnimatedSprite2D.play("Walk")
	$AnimatedSprite2D.flip_h = target_pos.x < global_position.x
	
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_pos, duration)
	
	# VARDIĞI AN YAPILACAKLAR:
	move_tween.finished.connect(func():
		$AnimatedSprite2D.play("Idle") # 1. Animasyonu Idle yap (Kaymayı keser)
		arrived.emit(self)            # 2. Makinaya "Geldim, süreyi başlat" de
	)
	
	return move_tween
	
func return_to_start():
	is_wandering = false
	if move_tween: move_tween.kill()
		
	if target_booth:
		target_booth.is_occupied = false
		GameData.booth_freed.emit()

	# Test için 1.0 yaptım, her kedi gider. Sonra 0.5 yaparsın.
	if randf() <= 1.0: 
		go_to_tip_box()
	else:
		walk_to_exit()

func go_to_tip_box():
	# walk_to zaten Walk animasyonunu başlatacak
	var tween = walk_to(GameData.tip_box_position)
	
	if tween:
		await tween.finished
	
	# walk_to içindeki finished sayesinde zaten Idle başladı, 
	# sadece parayı bırakma süresini bekliyoruz.
	await get_tree().create_timer(2.0).timeout 
	
	GameData.total_coins += 5
	GameData.print_status_report()
	
	walk_to_exit()
	

func walk_to_exit():
	is_wandering = false
	if move_tween:
		move_tween.kill()
		
	# Kapı koordinatın
	var exit_pos = Vector2(-100, 300) 
	
	var speed = 150.0
	var distance = global_position.distance_to(exit_pos)
	var duration = distance / speed
	
	# Animasyonu burada tekrar Walk yapıyoruz ki kaymasın
	$AnimatedSprite2D.play("Walk")
	$AnimatedSprite2D.flip_h = true 
	
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", exit_pos, duration)
	move_tween.finished.connect(queue_free)
