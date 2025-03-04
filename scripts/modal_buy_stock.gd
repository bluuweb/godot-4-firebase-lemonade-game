extends PanelContainer

@onready var button_buy: Button = %ButtonBuy

@onready var label_stock_modal: Label = %LabelStockModal
@onready var modal_button_up_stock: Button = %ModalButtonUpStock
@onready var modal_label_pre_stock: Label = %ModalLabelPreStock
@onready var modal_button_down_stock: Button = %ModalButtonDownStock
@onready var button_start: Button = %ButtonStart
@onready var button_buy_employee: Button = $MarginContainer/GridContainer/VBoxContainer3/ButtonBuyEmployee

# const UI = preload("res://scenes/ui.tscn") 
@onready var ui: CanvasLayer = $".."

var pre_stock := 0
var price_limonade_unit := 1
var cost := pre_stock * price_limonade_unit

signal game_start

func show_modal():
	self.show()
	initial_modal_config()
	
func button_update_text():
	button_buy.text = str("Comprar: \n$" , cost)

func initial_modal_config():
	button_buy.disabled = true
	button_update_text()
	label_stock_modal.text = str("Costo Limonada $", price_limonade_unit , " c/u")
	button_start.disabled = true
	update_button_buy_employee()

func update_pre_stock(value: int):
	pre_stock += value
	
	cost = pre_stock * price_limonade_unit
	button_buy.disabled = Global.profit < cost
	
	modal_label_pre_stock.text = str(pre_stock)
	button_update_text()

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
func _on_button_buy_pressed() -> void:
	
	
	await Global.update_stock(pre_stock)
	await Global.update_profit(-cost)
	
	%ButtonStart.grab_focus()
	
	# Aquí acceso al nodo parent (UI en este caso) 
	$"..".ui_profit.update_text("$ " + str(Global.profit))
	
	update_pre_stock(-pre_stock)
	button_buy.disabled = true
	
	update_button_buy_employee()
	
	if Global.stock > 0:
		button_start.disabled = false
		
	# Firestore
	await Global.firestore_put_stock_and_profit()

# Cuando se presiona el botón de start
func _on_button_start_pressed() -> void:
	game_start.emit()
	self.hide()

# Aquí se compra un empleado y se reduce en un 10% la venta de limonada
func _on_button_buy_employee_pressed() -> void:
	if Global.profit >= Global.employee_cost:
		if Global.employee_count >= Global.employee_max_number:
			update_button_buy_employee()
			return
		Global.employee_upgrade()
		update_button_buy_employee()
		$"..".ui_profit.update_text("$ " + str(Global.profit))
	else:
		print("Profit insuficiente")

func update_button_buy_employee():
	if Global.employee_count >= Global.employee_max_number:
		button_buy_employee.disabled = true
		button_buy_employee.text = str("Empleados \n Full Upgrade")
		return
		
	button_buy_employee.text = str("Empleados $" , Global.employee_cost, "\n +10% velocidad")
	if Global.profit >= Global.employee_cost:
		button_buy_employee.disabled = false
	else:
		button_buy_employee.disabled = true
