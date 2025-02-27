extends Control

@onready var label: Label = $PanelContainer/Label

func update_text(text: String):
	label.text = text
	
