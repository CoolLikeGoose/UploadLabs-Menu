extends Control

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
	var regex = RegEx.new()
	regex.compile("[^0-9.]")
	var clean_text = regex.sub(new_text, "", true)
	
	if clean_text != new_text:
		speed_line_edit.text = clean_text
		#speed_line_edit.caret_column = clean_text.length()
		
	print("GSD: new_text: *" + new_text + "*")
	print("GSD: clean_te: *" + clean_text + "*")
	
	if clean_text != "" and clean_text != ".":
		var val = clean_text.to_float()
		_on_speed_changed(val)
		speed_slider.value = val

func _update_speed_ui(value: float) -> void:
	speed_slider.value = value
	speed_line_edit.text = str(snappedf(value, 1))

func _ready() -> void:
	if speed_slider:
		speed_slider.value = Engine.time_scale
		speed_slider.connect("value_changed", Callable(self, "_on_speed_changed"))

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
