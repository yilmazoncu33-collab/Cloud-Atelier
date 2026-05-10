extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LoomerCatAnimatedSprite.play("LoomerCatAction")

func _on_timer_timeout() -> void:
	if GameData.total_cotton >= 10: # if greater than 10
		GameData.total_cotton -= 10 # 1. Pamukları harca
		
		GameData.total_thread += 1 # 2. Bir tane iplik üret
		
		GameData.data_updated.emit() # 3. UI'ı güncellemek için haber ver
		
		print("Thread produced! Total Thread: ", GameData.total_thread)
		print("Remaining Cotton: ", GameData.total_cotton)
	else:
		print("Not enough cotton for thread!") # 3. Console output
