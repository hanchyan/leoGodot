extends CanvasLayer

@onready var music = $MusicPlayer
@onready var portrait = $Portrait
@onready var speaker_label = $Panel/SpeakerLabel
@onready var text_label = $Panel/Label
@onready var button1 = $Panel/Button
@onready var button2 = $Panel/Button2
@onready var text_timer = $Panel/TextTimer

var dialogue = {}
var current_node = "start"

#two vars below are for typewriter effet 
var full_text = ""
var current_char = 0

func _ready():
	load_dialogue()
	show_node()
	music.play()


func load_dialogue():
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	var json_text = file.get_as_text()
	dialogue = JSON.parse_string(json_text)


func show_node():
	var node = dialogue[current_node]

	speaker_label.text = node["speaker"]
	full_text = node["text"]
	current_char = 0
	text_label.text = ""
	text_timer.start()
	



	if node.has("portrait"):
		var resource = load(node["portrait"])

		if resource is SpriteFrames:
			portrait.sprite_frames = resource
			portrait.play("idle")

		elif resource is Texture2D:
			var frames = SpriteFrames.new()
			frames.add_animation("idle")
			frames.add_frame("idle", resource)
			portrait.sprite_frames = frames
			portrait.play("idle")

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
	
func _on_text_timer_timeout():
	if current_char < full_text.length():
		text_label.text += full_text[current_char]
		current_char += 1
	else:
		text_timer.stop()
