extends Spatial


func _ready():
	var player_health = $Health
	var healthbar = $Healthbar
	
	player_health.connect("changed", healthbar, "set_value")
	player_health.connect("max_changed", healthbar, "set_max")
	player_health.initialize()
