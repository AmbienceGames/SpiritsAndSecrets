extends Node

func _on_button_pressed():
	visible = not visible
	#need to make it so that time pauses
	#also so that you can't switch screens (go mix drinks while time is not moving)

func _on_settings_pressed():
	print("me when i setting")

func _on_exit_pressed():
	print("me when i exit")

func _on_back_pressed():
	visible = not visible
