extends Spatial



func _on_AppleHit_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://Winscreen.tscn")
