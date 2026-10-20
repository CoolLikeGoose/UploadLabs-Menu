extends Control

var regex_number = RegEx.new()

#Speed modifier
@onready var speed_slider: HSlider = $TabContainer/Preferences/MarginContainer/SettingsContainer/GameSpeed/LabelContainer/HSlider
@onready var speed_reset: Button = $TabContainer/Preferences/MarginContainer/SettingsContainer/GameSpeed/LabelContainer/Reset
@onready var speed_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/GameSpeed/LabelContainer/LineEdit

func _on_speed_changed(value: float) -> void:
	Globals.set_offline_multiplier(value)
	_update_speed_ui(value)

func _on_speed_slider_changed(value_changed: bool) -> void:
	if (!value_changed):
		return
	_on_speed_changed(speed_slider.value)

func _on_speed_label_changed(new_text: String) -> void:
	var clean_text = regex_number.sub(new_text, "", true)

	if clean_text != new_text:
		speed_line_edit.text = clean_text

	if clean_text != "" and clean_text != ".":
		var val = clean_text.to_int()
		_on_speed_changed(val)

func _update_speed_ui(value: float) -> void:
	speed_slider.value = value
	speed_line_edit.text = str(int(value))

# Buttons


func _ready() -> void:
	regex_number.compile("[^0-9]")
	if speed_slider:
		speed_slider.value = 1
		speed_slider.connect("value_changed", Callable(self, "_on_speed_changed"))

func _process(delta: float) -> void:
	if Globals and Attributes:
		var max_time = Attributes.get_attribute("max_rest_time")
		Globals.offline_time = max_time

	#if add_money_btn:
		#add_money_btn.connect("pressed", Callable(self, "_on_add_money_pressed"))

func _on_add_money_pressed() -> void:
	if Globals and "currencies" in Globals:
		Globals.currencies["token"] += 1000000
		if "stats" in Globals:
			Globals.stats.max_tokens += 1000000

# Links handlers
func _on_steam_pressed() -> void:
	pass

func _on_github_pressed() -> void:
	pass
