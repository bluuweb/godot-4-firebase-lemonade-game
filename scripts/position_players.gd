extends PanelContainer

@onready var grid_container: GridContainer = $GridContainer

# Configuración
var LIMIT = 10
var ORDERBY = "profit"
var ORDER = "desc"
const PROJECT_ID = "twitch-game-1"
const COLLECTION_NAME = "users"
var BASE_URL = str("https://firestore.googleapis.com/v1/projects/", PROJECT_ID, "/databases/(default)/documents/")
var FIRESTORE_URL = str(BASE_URL, COLLECTION_NAME, "?orderBy=", ORDERBY, "%20", ORDER, "&pageSize=", LIMIT)

const HEADERS = ["Content-Type: application/json", "Accept-Encoding: identity"]  # ⚠️ Eliminamos "Accept-Encoding: gzip"
@onready var http_request: HTTPRequest = $HTTPRequest

func _ready():
	print(FIRESTORE_URL)
	fetch_users()
	print("HEADERS: ", HEADERS)

func fetch_users():
	var error = http_request.request(FIRESTORE_URL, HEADERS, HTTPClient.METHOD_GET)
	if error != OK:
		print("🧨 Error en la solicitud:", error)
		return
	
	print("Solicitud enviada correctamente.")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("GET: ", response_code)
	
	if response_code == 400:
		var body_str = body.get_string_from_utf8()
		print("400: ", body_str)
		return
	
	if response_code == 200:
		var body_str = body.get_string_from_utf8()
		if body_str.is_empty():
			print("⚠️ El cuerpo de la respuesta está vacío.")
			return
		
		# Analizar el JSON
		var json = JSON.new()
		var parse_result = json.parse(body_str)
		
		if parse_result == OK:
			var data = json.get_data()
			print("Datos recibidos: ", data)
			print_users_rank(data.documents)
		else:
			print("Error al analizar JSON: ", json.get_error_message())

func print_users_rank(users):
	await clear_grid_container()
	
	for user in users:
		var profit = user.fields.profit.integerValue
		var email = user.fields.email.stringValue
		
		var labelProfit = Label.new()
		labelProfit.text = str(profit)
		grid_container.add_child(labelProfit)
		
		var labelEmail = Label.new()
		labelEmail.text = email
		grid_container.add_child(labelEmail)

func clear_grid_container():
	var grid_container = $GridContainer  # Referencia al nodo contenedor
	for child in grid_container.get_children():
		child.queue_free()  # Marca los hijos para eliminarse en el próximo frame
