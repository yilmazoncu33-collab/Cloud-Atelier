extends Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Kendi yerini GameData'ya yazdırıyoruz
	GameData.tip_box_position = global_position
