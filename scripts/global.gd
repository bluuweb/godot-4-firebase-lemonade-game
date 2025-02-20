extends Node

var price := 1
var profit := 0
var stock := 100

var http_request_get = HTTPRequest.new()
var http_request_put = HTTPRequest.new()

const url = "https://juego-v1-a09be-default-rtdb.firebaseio.com/score.json"
const headers = ["Content-Type: application/json"]

func _ready():
	add_child(http_request_get)
	http_request_get.request_completed.connect(self._http_request_get_completed)
	
	add_child(http_request_put)
	http_request_put.request_completed.connect(self._http_request_put_completed)
	
	read_data()
	
func sell_lemonade():
	if(stock > 0):
		stock -= 1
		profit += price
		send_data()
		
func read_data():
	http_request_get.request(url, headers, HTTPClient.METHOD_GET)

func send_data():
	var data = { "stock": stock, "profit": profit, "price": price }
	var dataJSON = JSON.stringify(data)
	http_request_put.request(url, headers, HTTPClient.METHOD_PUT, dataJSON)

func data_sync(data):
	price = data.price
	stock = data.stock
	profit = data.profit

func _http_request_get_completed(result, response_code, headers, body):
	print("GET: ", response_code)
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		#print("datos recibidos: ", data)
		data_sync(data)

func _http_request_put_completed(result, response_code, headers, body):
	print("PUT: ", response_code)
