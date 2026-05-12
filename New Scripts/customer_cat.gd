extends Node2D
signal arrived
var target_position = Vector2(500, 300)
var start_position = Vector2(-50, 300)
var move_duration = 4.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walk_to(target_position)

# Yürüme işini genel bir fonksiyona çevirdik ki geri dönerken de kullanalım
func walk_to(target: Vector2, is_returning: bool = false):
	$AnimatedSprite2D.play("Walk")
	
	# Eğer geri dönüyorsa sprite'ı ters çevir (sola baksın)
	$AnimatedSprite2D.flip_h = is_returning
	
	var tween = create_tween()
	tween.tween_property(self, "position", target, move_duration)
	
	tween.finished.connect(func():
		$AnimatedSprite2D.stop()
		if is_returning:
			queue_free() # Geri geldiyse kendini yok et (RAM'i şişirme)
		else:
			arrived.emit() # Hedefe vardıysa sinyal çak
	)

# Shop bu fonksiyonu çağıracak
func return_to_start():
	walk_to(start_position, true)
