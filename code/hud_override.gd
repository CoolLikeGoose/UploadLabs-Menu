extends "res://scripts/hud.gd"

var goose_tab_index: int = -1
var goose_btn: Button = null

func _ready() -> void:
	super._ready()
	_inject_goose_tab()

func _inject_goose_tab() -> void:
	var menus_node = get_node_or_null("Main/MainContainer/Overlay/Menus")
	var extras_buttons_container = get_node_or_null("Main/MainContainer/Overlay/ExtrasButtons/Container")
	
	if not menus_node or not extras_buttons_container:
		ModLoaderLog.error("GSD: Cant find containers for button injection", "CoolLikeGoose-GooseMenu")
		return
	
	# Inject tab
	var goose_tab_scene = load("res://mods-unpacked/CoolLikeGoose-GooseMenu/scenes/GooseMenuTab.tscn")
	var goose_tab_node : Variant
	
	if goose_tab_scene:
		goose_tab_node = goose_tab_scene.instantiate()
		goose_tab_node.name = "GooseMenu" 
		
		menus_node.add_child(goose_tab_node)
		
		goose_tab_node.offset_right = menus_node.size.x - 15
		goose_tab_node.offset_left = menus_node.size.x
		
		goose_tab_node.hide()

	# Inject button
	var template_btn = extras_buttons_container.get_child(0) if extras_buttons_container.get_child_count() > 0 else null
	
	if template_btn:
		goose_btn = template_btn.duplicate()
		for connection in goose_btn.pressed.get_connections():
			goose_btn.pressed.disconnect(connection["callable"])
		
		var goose_icon = load("res://mods-unpacked/CoolLikeGoose-GooseMenu/assets/logoBW(icon).png")
		if goose_icon:
			goose_btn.icon = goose_icon
		goose_btn.text = ""
	else:
		# indicates that something during injection went wrong
		goose_btn = Button.new()
		goose_btn.text = "🪿"

	extras_buttons_container.add_child(goose_btn)
	goose_btn.name = "GooseMenuButton"
	
	goose_tab_index = menus_node.get_child_count() - 1
	var menus_script = get_node_or_null("Main/MainContainer/Overlay/Menus")
	
	goose_btn.pressed.connect(func():
		if not menus_script:
			print("GSD: proebali menu script")
			return
			
		if not menus_script.open:
			menus_script.cur_tab = goose_tab_index
			set_menu(Utils.menu_types.SIDE, goose_tab_index, true)
			return

		if menus_script.cur_tab == goose_tab_index:
			set_menu(Utils.menu_types.NONE)
		else:
			set_menu(Utils.menu_types.SIDE, goose_tab_index, true)
	)

func update_buttons() -> void:
	super.update_buttons()
	
	var menus_script = get_node_or_null("Main/MainContainer/Overlay/Menus")
	
	if goose_btn and menus_script:
		goose_btn.button_pressed = menus_script.open and menus_script.cur_tab == goose_tab_index
