extends Node

# Toplam pamuk miktarını tutar
var total_cotton: int = 0 #Total Cotton
var total_thread: int = 0 #Total Thread
var total_tshirt: int = 0 #Total Tshirt
# Veri değiştiğinde diğer her yere (UI vb.) haber veren sinyal
signal data_updated
