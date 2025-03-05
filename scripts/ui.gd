extends CanvasLayer

@export var cursor_image: Texture2D
@onready var button_start: Button = $ButtonStart
@onready var ui_profit: Node = $UIProfit
@onready var ui_price: Control = $UIPrice
@onready var ui_stock: Control = $UIStock

@onready var label_email_user: Label = $LabelEmailUser

var auth = null

func _ready() -> void:
	auth = Firebase.Auth.auth
	if auth:
		$ModalLoading.show()
		label_email_user.text = auth.email
		var collection = Firebase.Firestore.collection("users")
		var document: FirestoreDocument = await collection.get_doc(auth.localid)
		Global.initial_data_current_user(document)
		$ModalLoading.hide()
	
	#modal_initial_config()
	$ModalBuyStock.show()
	
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
	$ModalBuyStock.initial_modal_config() # TODO: por qué el @onready no funciona aquí

func update_stock():
	ui_stock.update_text("Stock: " + str(Global.stock))

func sell():
	ui_profit.update_text("$ " + str(Global.profit))
	$UIProfit/AnimatedGold.play("sell")
	
	ui_stock.update_text("Stock: " + str(Global.stock))

# Aumentar el precio
func _on_button_price_up_pressed() -> void:
	Global.update_price(1)
	ui_price.update_text("Price: " + str(Global.price))

# Disminuir el precio
func _on_button_price_down_pressed() -> void:
	Global.update_price(-1)
	ui_price.update_text("Price: " + str(Global.price))

# Cerrar sesión de usuario
func _on_button_logout_pressed() -> void:
	Firebase.Auth.logout()
	Global.reset_new_game()
	get_tree().change_scene_to_file("res://scenes/login.tscn")
