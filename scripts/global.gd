extends Node

var price := 2
var profit := 30000
var stock := 0
var time_game := 30
var bonus_time := 10
var time_wait_for_limonade := 3.0

# Upgrade games
var employee_upgrade_percent = 0.1
var employee_count = 1
var employee_cost_base = 50
var employee_cost = 50
var employee_max_number = 57

var http_request_get = HTTPRequest.new()
var http_request_put = HTTPRequest.new()

const url = "https://juego-v1-a09be-default-rtdb.firebaseio.com/score.json"
const headers = ["Content-Type: application/json"]

signal sell
signal update_stock_signal
signal update_price_signal

func _ready():
	
	sell.connect(sell_lemonade)
	
	add_child(http_request_get)
	http_request_get.request_completed.connect(self._http_request_get_completed)
	
	add_child(http_request_put)
	http_request_put.request_completed.connect(self._http_request_put_completed)
	
	# read_data()

func employee_upgrade():
	if employee_count >= employee_max_number:
		return
	
	update_profit(-employee_cost)
	time_wait_for_limonade += -time_wait_for_limonade * employee_upgrade_percent
	employee_count += 1
	print("employee_count ", employee_count)
	employee_cost = employee_count * employee_cost_base

func sell_lemonade():
	if(stock > 0):
		stock -= 1
		profit += price
		#time_game += bonus_time
		# send_data()
		
func update_price(value: int):
	price += value
	update_price_signal.emit()
	
func update_stock(value: int):
	print("update_stock global", value)
	stock += value
	update_stock_signal.emit()

func update_profit(value: int):
	profit += value
		
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

func _http_request_get_completed(_result, response_code, _headers, body):
	print("GET: ", response_code)
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		#print("datos recibidos: ", data)
		data_sync(data)

func _http_request_put_completed(_result, response_code, _headers, _body):
	print("PUT: ", response_code)
