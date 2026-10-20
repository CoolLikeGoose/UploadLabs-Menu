extends Node

const MOD_NAME = "CoolLikeGoose-GooseMenu"

func _init() -> void:
	ModLoaderMod.install_script_extension("res://mods-unpacked/" + MOD_NAME + "/code/hud_override.gd")

func _ready() -> void:
	ModLoaderLog.info("GooseMenu loaded", "CoolLikeGoose-GooseMenu")
