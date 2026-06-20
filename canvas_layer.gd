extends CanvasLayer

@onready var portrait = $Panel/Portrait
@onready var speaker_label = $Panel/SpeakerLabel
@onready var text_label = $Panel/Label
@onready var button1 = $Panel/Button
@onready var button2 = $Panel/Button2

var dialogue = {}
var current_node = "start"

func _ready():
	load_dialogue()
	show_node()

func load_dialogue():
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	var json_text = file.get_as_text()
	dialogue = JSON.parse_string(json_text)

func show_node():
	
	var node = dialogue[current_node]
	
	speaker_label.text = node["speaker"]
	text_label.text = node["text"]
	
	if node.has("portrait"):
		portrait.texture = load(node["portrait"])
		portrait.show()
	else:
		portrait.hide()

	if node["choices"].size() > 0:
		button1.show()
		button1.text = node["choices"][0]["text"]

		if node["choices"].size() > 1:
			button2.show()
			button2.text = node["choices"][1]["text"]
		else:
			button2.hide()
	else:
		button1.hide()
		button2.hide()


func _on_button_pressed():
	current_node = dialogue[current_node]["choices"][0]["next"]
	show_node()


func _on_button_2_pressed():
	current_node = dialogue[current_node]["choices"][1]["next"]
	show_node()
