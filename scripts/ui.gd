extends CanvasLayer

@onready var label_price: Label = $VBoxContainer/LabelPrice
@onready var label_stock: Label = $VBoxContainer/LabelStock
@onready var label_profit: Label = $LabelProfit
@export var cursor_image: Texture2D
@onready var animate_button_start: AnimatedSprite2D = $Button/AnimateButtonStart

func _ready() -> void:
	# Verifica que la imagen del cursor esté cargada
	if cursor_image:
		# Configura el cursor personalizado
		Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	else:
		print("La imagen del cursor no está cargada.")

func _process(delta: float) -> void:
	label_price.text = "Price: $" + str(Global.price)
	label_stock.text = "Stock: " + str(Global.stock)
	label_profit.text = "$ " + str(Global.profit)

func _on_button_pressed() -> void:
	animate_button_start.play("click")
