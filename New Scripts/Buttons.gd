extends CanvasLayer

@onready var camera = get_node("/root/Main/Camera2D")

# Ekran noktalarımız (Kameranın duracağı merkez noktalar)
var shop_pos = Vector2(0, 0)   # Shop'un merkezi
var atelier_pos = Vector2(1200, 0) # Atelier'in merkezi (1200 + 576)

func _on_left_button_pressed() -> void:
	move_camera(shop_pos)
	
func _on_right_button_pressed() -> void:
	move_camera(atelier_pos)
	
func move_camera(target_pos: Vector2):
	var tween = create_tween()
	# Kamerayı 0.5 saniyede hedef noktaya yumuşakça kaydır
	tween.tween_property(camera, "position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
