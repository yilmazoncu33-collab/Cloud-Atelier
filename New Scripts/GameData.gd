extends Node

var total_coins: int = 0
var tip_box_position: Vector2 = Vector2.ZERO
var waiting_cats: Array = []
var trial_booths: Array = []
# EKSİK OLAN VE HATAYA SEBEP OLAN SATIR TAM OLARAK BU:
var incoming_cats: Array = [] 

signal new_cat_ready
signal request_boost_spawns
signal booth_freed

func print_status_report():
	var active_machines = 0
	# Makine sayısını hesaplıyoruz
	for m in get_tree().get_nodes_in_group("machines"):
		if m.is_working: 
			active_machines += 1

	print("\n--- DÜKKAN CANLI TAKİP ---")
	print("🚶 Yoldaki (Yürüyen) Kediler: ", incoming_cats.size())
	print("📍 Kabine Varmış Bekleyenler: ", waiting_cats.size())
	print("👕 Makinede İşlemde Olanlar: ", active_machines)
	print("💰 Kasa: ", total_coins)
	print("--------------------------\n")
	
func get_total_cat_count() -> int:
	var active_machines = 0
	for m in get_tree().get_nodes_in_group("machines"):
		if m.is_working:
			active_machines += 1
	
	# Yoldakiler + Bekleyenler + Makinadakiler
	return incoming_cats.size() + waiting_cats.size() + active_machines

func get_max_capacity() -> int:
	# Kabin sayısının 2 katı
	return trial_booths.size() * 2
