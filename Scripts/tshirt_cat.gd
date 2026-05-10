extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TshirtCatAnimatedSprite.stop()

func _on_timer_timeout() -> void:
	if GameData.total_thread >= 10:
		$TshirtCatAnimatedSprite.play("TshirtAction") # 1. İş yaparsa animasyonu çalıştır.
		GameData.total_thread -= 10 # 2. İplikleri harca
		GameData.total_tshirt += 1 # 3. Bir tişört üret
		
		GameData.data_updated.emit() # 4. Herkese haber ver

		print("T-shirt produced! Total T-shirts: ", GameData.total_tshirt)
	else:
		$TshirtCatAnimatedSprite.stop() # İplik yetersizse animasyonu durdur
		print("Waiting for thread... Textile cat is resting.")
