extends Node2D

@onready var http_request: HTTPRequest = $HTTPRequest
const url = "https://juego-v1-a09be-default-rtdb.firebaseio.com/jugadores.json"
const headers = ["Content-Type: application/json"]

func _ready() -> void:
	# send_data()
	# read_data()
	pass

func read_data():
	http_request.request(url, headers, HTTPClient.METHOD_GET)

func send_data():
	var data = { "nombre": "Jugador 1", "puntos": 100 }
	var dataJSON = JSON.stringify(data)
	http_request.request(url, headers, HTTPClient.METHOD_PUT, dataJSON)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	#print("Código de respuesta:", response_code)
	#print("Respuesta:", body.get_string_from_utf8())
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		print("datos recibidos: ", data)
