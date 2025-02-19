extends Control

@onready var label_price: Label = $VBoxContainer/LabelPrice
@onready var label_stock: Label = $VBoxContainer/LabelStock
@onready var label_profit: Label = $VBoxContainer/LabelProfit

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	label_price.text = "Price: $" + str(Global.price)
	label_stock.text = "Stock: " + str(Global.stock)
	label_profit.text = "Profit: $" + str(Global.profit)
