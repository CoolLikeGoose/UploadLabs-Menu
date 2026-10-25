extends Control

var regex_number = RegEx.new()

func convert_to_float_number(text: String) -> float:
	text = text.strip_edges().to_lower().replace(",", ".")
	var length = text.length()
	if length == 0:
		return 0.0
		
	var base_multipliers = {
		"k": 1e3,
		"m": 1e6,
		"b": 1e9,
		"t": 1e12, # game suffixes ends here
		"qa": 1e15,
		"qi": 1e18,
		"sx": 1e21,
		"sp": 1e24,
		"oc": 1e27,
		"no": 1e30,
		"de": 1e33
	}
	
	# 2-letter suffixes like aa ab  
	if length >= 3:
		var last_two = text.substr(length - 2, 2)
		if last_two[0] >= "a" and last_two[0] <= "z" and last_two[1] >= "a" and last_two[1] <= "z":
			var num_part = text.substr(0, length - 2).to_float()
			var c1 = last_two.unicode_at(0) - 97 # 'a'
			var c2 = last_two.unicode_at(1) - 97
			var index = (c1 * 26) + c2
			# aa = 1e15
			var power = 15 + (index * 3)
			return num_part * pow(10.0, power)

	# standart 2-letter suffixes
	if length >= 2:
		var last_two_short = text.substr(length - 2, 2)
		if base_multipliers.has(last_two_short):
			var num_part = text.substr(0, length - 2).to_float()
			return num_part * base_multipliers[last_two_short]

	# 1-letter suffixes
	var last_one = text.substr(length - 1, 1)
	if base_multipliers.has(last_one):
		var num_part = text.substr(0, length - 1).to_float()
		return num_part * base_multipliers[last_one]

	# no suffix
	return text.to_float()

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

# Resources
@onready var token_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/ResourcesEdit/Row1/Tokens/TokenLineEdit
func _on_token_label_changed(new_text: String) -> void:
	if Globals and "currencies" in Globals:
		Globals.currencies["token"] = convert_to_float_number(new_text)
		token_line_edit.clear()

@onready var money_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/ResourcesEdit/Row1/Money/MoneyLineEdit
func _on_money_label_changed(new_text: String) -> void:
	if Globals and "currencies" in Globals:
		Globals.currencies["money"] = convert_to_float_number(new_text)
		money_line_edit.clear()

@onready var science_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/ResourcesEdit/Row1/Science/ScienceLineEdit
func _on_science_label_changed(new_text: String) -> void:
	if Globals and "currencies" in Globals:
		Globals.currencies["research"] = convert_to_float_number(new_text)
		science_line_edit.clear()

# Points
@onready var hack_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/PointsEdit/HBoxContainer/HackPoint/hackLineEdit
func _on_hack_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("hack_points", [convert_to_float_number(new_text), 0, 0])
		hack_line_edit.clear()
		
@onready var opt_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/PointsEdit/HBoxContainer/OptPoint/optLineEdit
func _on_opt_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("optimization", [convert_to_float_number(new_text), 0, 0])
		opt_line_edit.clear()

@onready var app_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/PointsEdit/HBoxContainer/AppPoint/appLineEdit
func _on_app_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("application", [convert_to_float_number(new_text), 0, 0])
		app_line_edit.clear()

# Advanced research
@onready var tech_res_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/AdvResearchEdit/HBoxContainer/TechPoint/techResLineEdit
func _on_tech_res_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("tech_research", [convert_to_float_number(new_text), 0, 0])
		tech_res_line_edit.clear()

@onready var hack_res_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/AdvResearchEdit/HBoxContainer/HackPoint/hackResLineEdit
func _on_hack_res_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("hack_research", [convert_to_float_number(new_text), 0, 0])
		hack_res_line_edit.clear()

@onready var code_res_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/AdvResearchEdit/HBoxContainer/CodePoint/codeResLineEdit
func _on_code_res_line_edit_text_submitted(new_text: String) -> void:
	if Attributes:
		Attributes.apply_attribute("code_research", [convert_to_float_number(new_text), 0, 0])
		code_res_line_edit.clear()

# Alien things
@onready var alien_tech_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/AlienThingsEdit/HBoxContainer/AlienTech/alienTechLineEdit
func _on_alien_tech_line_edit_text_submitted(new_text: String) -> void:
	if Globals and "currencies" in Globals:
		Globals.currencies["alien_research"] = convert_to_float_number(new_text)
		alien_tech_line_edit.clear()

@onready var entropy_line_edit: LineEdit = $TabContainer/Preferences/MarginContainer/SettingsContainer/AlienThingsEdit/HBoxContainer/Entropy/entropyLineEdit
func _on_entropy_line_edit_text_submitted(new_text: String) -> void:
	if Globals:
		Globals.add_entropy_levels(convert_to_float_number(new_text))
		entropy_line_edit.clear()

func _ready() -> void:
	regex_number.compile("[^0-9]")
	if speed_slider:
		speed_slider.value = 1
		speed_slider.connect("value_changed", Callable(self, "_on_speed_changed"))

func _process(delta: float) -> void:
	if Globals and Attributes:
		var max_time = Attributes.get_attribute("max_rest_time")
		Globals.offline_time = max_time

# Links handlers
func _on_steam_pressed() -> void:
	OS.shell_open("https://github.com/CoolLikeGoose/UploadLabs-Menu")
	Sound.play("click")

func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/CoolLikeGoose/UploadLabs-Menu/")
	Sound.play("click")
