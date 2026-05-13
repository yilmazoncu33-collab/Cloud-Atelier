extends Node2D

var is_working: bool = false # Makine şu an meşgul mü?
var current_cat = null

@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	# Ortak zili dinle: "Yeni kedi geldiğinde sırayı kontrol et"
	GameData.new_cat_arrived.connect(check_queue)
	# Oyun başında bekleyen kedi varsa diye bir kez kontrol et
	check_queue()
	
func check_queue():
	# Eğer boşta isem VE sırada bekleyen kedi varsa
	if !is_working and GameData.waiting_cats.size() > 0:
		start_machine()

func start_machine():
	is_working = true
	# Sıradaki ilk kediyi kap (M/M/s kuyruk mantığı kanka)
	current_cat = GameData.waiting_cats.pop_front()
	
	anim_sprite.play("Work")
	timer.start()
	
	print("Machine started for a new customer...")
	anim_sprite.play("Work")
	timer.start()

func _on_timeout():
	anim_sprite.stop()
	is_working = false
	GameData.total_coins += 10
	print("Total coins:", GameData.total_coins)
	if current_cat != null:
		current_cat.return_to_start()
		current_cat = null
	
	# İş bitti, sırada bekleyen başka kedi var mı bak
	check_queue()
