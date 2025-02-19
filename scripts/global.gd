extends Node

var price := 1
var profit := 0
var stock := 100

var http_request = HTTPRequest.new()
const url = "https://juego-v1-a09be-default-rtdb.firebaseio.com/score.json"
const headers = ["Content-Type: application/json"]

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	read_data()
	
func sell_lemonade():
	if(stock > 0):
		stock -= 1
		profit += price
		send_data()
		
func read_data():
	http_request.request(url, headers, HTTPClient.METHOD_GET)

func send_data():
	var data = { "stock": stock, "profit": profit, "price": price }
	var dataJSON = JSON.stringify(data)
	http_request.request(url, headers, HTTPClient.METHOD_PUT, dataJSON)

func data_sync(data):
	price = data.price
	stock = data.stock
	profit = data.profit

func _http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		#print("datos recibidos: ", data)
		data_sync(data)
