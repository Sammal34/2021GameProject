extends Control




func _on_Button_pressed():
	get_tree().change_scene("res://World3d.tscn")


func _on_Back_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")
