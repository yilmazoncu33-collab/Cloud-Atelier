extends CanvasLayer

@onready var bar = $Button/ProgressBar
var click_count: int = 0

func _on_button_pressed() -> void:
	if click_count < 6:
		click_count += 1
		bar.value = click_count
		print("Tik sayisi: ", click_count)
		
		# BAR DOLDU!
		if click_count == 6:
			# 1. Spawner'a "Kedileri gönder" emri ver
			GameData.request_boost_spawns.emit()
			
			# 2. SIFIRLAMA: Her şeyi başa sar
			click_count = 0
			bar.value = 0
			print("Bar doldu, kediler gonderildi ve sistem sifirlandi!")
