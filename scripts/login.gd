extends Node2D

@onready var line_edit_input: LineEdit = $VBoxContainer/HBoxContainer/LineEditInput
@onready var label_error: Label = $VBoxContainer/LabelError

func _ready() -> void:
	label_error.hide()
	
func show_error(text_error: String):
	label_error.text = text_error
	label_error.show()
	
func _on_button_login_pressed() -> void:
	if line_edit_input.text.strip_edges() == "":
		show_error("Escribe un nombre válido")
		line_edit_input.grab_focus()
		return
		
	print(line_edit_input.text)

func _on_line_edit_input_text_changed(new_text: String) -> void:
	if new_text.strip_edges() != "":
		label_error.hide()
	else:
		show_error("No se aceptan espacios en blanco")
