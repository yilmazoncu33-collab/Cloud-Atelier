extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Animasyonu Başlat
	$CloudFarmerAnimatedSprite.play("CloudFarmerCat")

func _on_timer_timeout() -> void:
	# Bankaya (GameData) 10 pamuk ekle
	GameData.total_cotton += 10
	
	# Tüm oyuna "veri güncellendi" diye haber uçur
	GameData.data_updated.emit()
	
	# Çalışıp çalışmadığını anlamak için aşağıya yazı yazdır
	print("Collected 10 cotton! Total now: ", GameData.total_cotton)
