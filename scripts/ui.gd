extends CanvasLayer

@export var cursor_image: Texture2D
@onready var button_start: Button = $ButtonStart
@onready var ui_profit: Node = $UIProfit
@onready var ui_price: Node2D = $UIPrice
@onready var ui_stock: Node2D = $UIStock

#@onready var ModalBuyStock: Node2D = $Modal

signal game_start

func _ready() -> void:
	modal_initial_config()
	
	Global.connect("sell", sell)
	Global.connect("update_stock_signal", update_stock)
	
	ui_profit.update_text("$ " + str(Global.profit))
	ui_price.update_text("Price: " + str(Global.price))
	ui_stock.update_text("Stock: " + str(Global.stock))
	
	# Verifica que la imagen del cursor esté cargada
	if cursor_image:
		return
		# Configura el cursor personalizado
		Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	else:
		print("La imagen del cursor no está cargada.")

func modal_initial_config():
	button_start.disabled = true
	$ModalBuyStock.initial_modal_config() # TODO: por qué el @onready no funciona aquí

func update_stock():
	ui_stock.update_text("Stock: " + str(Global.stock))
	if Global.stock > 0:
		button_start.disabled = false

func sell():
	ui_profit.update_text("$ " + str(Global.profit))
	ui_profit.animate()
	
	ui_stock.update_text("Stock: " + str(Global.stock))

func _on_button_pressed() -> void:
	# Aquí llamo a World
	# $"..".game_start()
	game_start.emit()

	#await get_tree().create_timer(0.5).timeout
	# Ocultar el botón animate_button_start
	button_start.hide()
	$ModalBuyStock.hide()
	

# Aumentar el precio
func _on_button_price_up_pressed() -> void:
	Global.update_price(0.5)
	ui_price.update_text("Price: " + str(Global.price))

# Disminuir el precio
func _on_button_price_down_pressed() -> void:
	Global.update_price(-0.5)
	ui_price.update_text("Price: " + str(Global.price))
