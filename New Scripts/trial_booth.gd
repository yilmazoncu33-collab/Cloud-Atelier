extends Node2D

var is_occupied: bool = false
var current_customer = null

func _ready():
	# Oyun başlar başlamaz kabin kendini "Ben buradayım" diye listeye eklesin
	GameData.trial_booths.append(self)
