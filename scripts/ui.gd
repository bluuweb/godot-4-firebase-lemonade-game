extends CanvasLayer

#@onready var label_price: Label = $VBoxContainer/LabelPrice
#@onready var label_stock: Label = $VBoxContainer/LabelStock
#@onready var label_profit: Label = $LabelProfit

@export var cursor_image: Texture2D
@onready var button_start: Button = $ButtonStart
@onready var ui_profit: Node = $UIProfit
@onready var ui_price: Node2D = $UIPrice
@onready var ui_stock: Node2D = $UIStock

signal game_start

func _ready() -> void:
	Global.connect("sell", sell)
	Global.connect("update_stock_signal", update_stock)
	
	ui_profit.update_text("$ " + str(Global.profit))
	ui_price.update_text("Price: " + str(Global.price))
	ui_stock.update_text("Stock: " + str(Global.stock))
	
	# Verifica que la imagen del cursor esté cargada
	if cursor_image:
		# Configura el cursor personalizado
		Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	else:
		print("La imagen del cursor no está cargada.")

func update_stock():
	ui_stock.update_text("Stock: " + str(Global.stock))

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
