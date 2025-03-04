extends Node2D

@onready var label_error: Label = $VBoxContainer/LabelError
@onready var input_email: LineEdit = $VBoxContainer/InputEmail
@onready var input_password: LineEdit = $VBoxContainer/InputPassword

const COLLECTION_NAME = "users"

func _ready() -> void:
	label_error.hide()
	# Conectar las señales
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	if Firebase.Auth.check_auth_file():
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func show_error(text_error: String):
	label_error.text = text_error
	label_error.show()

func toggle_state_button(state: bool):
	$VBoxContainer/HBoxContainer/ButtonRegister.disabled = state
	$VBoxContainer/HBoxContainer/ButtonLogin.disabled = state

# Aquí hacemos Register del formulario
func _on_button_register_pressed() -> void:
	Firebase.Auth.signup_with_email_and_password(input_email.text, input_password.text)
	
# Aquí hacemos Login del formulario
func _on_button_login_pressed() -> void:
	if input_email.text.strip_edges() == "":
		show_error("Escribe un email válido")
		input_email.grab_focus()
		return
	
	toggle_state_button(true)
	
	await Firebase.Auth.login_with_email_and_password(input_email.text, input_password.text)

# Login exitoso
func _on_FirebaseAuth_login_succeeded(auth):
	# Guardar los datos de autenticación para uso futuro
	Firebase.Auth.save_auth(auth)
	
	# 1. Usuario que no existe
	var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME)
	var document: FirestoreDocument = await collection.get_doc(auth.localid)
	
	if !document:
		# Si no existe
		var data: Dictionary = {
			"localid" : auth.localid,
			"email": auth.email,
			"profit": Global.profit,
			"stock": Global.stock,
			"price": Global.price,
			"time_wait_for_limonade": Global.time_wait_for_limonade,
			"employee_count": Global.employee_count,
			"employee_cost": Global.employee_cost
		}
		await collection.add(auth.localid, data)
	else:
		# 2. usuario que si existe
		Global.initial_data_current_user(document)
	
	toggle_state_button(false)
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func on_login_failed(error_code, message):
	toggle_state_button(false)
	print("error code: " + str(error_code))
	print("message: " + str(message))
	show_error(message.to_lower())

func on_signup_failed(error_code, message: String):
	toggle_state_button(false)
	print("error code: " + str(error_code))
	print("message: " + str(message))
	show_error(message.to_lower())
	
# Aquí verificamos el email en tiempo real
func _on_line_edit_input_text_changed(new_text: String) -> void:
	if new_text.strip_edges() != "":
		label_error.hide()
	else:
		show_error("No se aceptan espacios en blanco")
