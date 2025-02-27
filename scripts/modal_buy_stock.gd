extends PanelContainer

@onready var modal_button_buy: Button = %ModalButtonBuy
@onready var label_stock_modal: Label = %LabelStockModal
@onready var modal_button_up_stock: Button = %ModalButtonUpStock
@onready var modal_label_pre_stock: Label = %ModalLabelPreStock
@onready var modal_button_down_stock: Button = %ModalButtonDownStock
@onready var button_start: Button = %ButtonStart

# const UI = preload("res://scenes/ui.tscn")
@onready var ui: CanvasLayer = $".."

var pre_stock := 0
var price_limonade_unit := 2
var cost := 0

signal game_start

func _ready() -> void:
	pass 

func initial_modal_config():
	modal_button_buy.disabled = true
	modal_button_buy.text = str("Comprar: $" , pre_stock * price_limonade_unit)
	label_stock_modal.text = str("Costo Limonada $", price_limonade_unit , " c/u")

	button_start.disabled = true
func update_pre_stock(value: int):
	pre_stock += value
	
	cost = pre_stock * price_limonade_unit
	modal_button_buy.disabled = Global.profit < cost
	
	modal_label_pre_stock.text = str(pre_stock)
	modal_button_buy.text = str("Comprar: $" , cost)

# Aumentar stock
func _on_modal_button_up_stock_pressed() -> void:
	update_pre_stock(1)
	
# Disminuir stock
func _on_modal_button_down_stock_pressed() -> void:
	if pre_stock > 0:
		update_pre_stock(-1)
	else:
		print("No se puede disminuir más...", pre_stock)

# Cuando se presiona el botón de comprar stock
func _on_modal_button_buy_pressed() -> void:
	print("se presionó el boton de comprar")
	Global.update_stock(pre_stock)
	Global.update_profit(-cost)
	
	# Aquí acceso al nodo parent (UI en este caso) 
	$"..".ui_profit.update_text("$ " + str(Global.profit))
	
	update_pre_stock(-pre_stock)
	modal_button_buy.disabled = true
	
	if Global.stock > 0:
		button_start.disabled = false

# Cuando se presiona el botón de start
func _on_button_start_pressed() -> void:
	game_start.emit()
	self.hide()
