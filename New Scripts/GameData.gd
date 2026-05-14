extends Node

var total_coins: int = 0
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
