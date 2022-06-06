extends CanvasLayer

const bar_width_max = 125

func _on_Player_player_stats_changed(var player):
	var mana_per_pixel = float(bar_width_max) / float(player.health_max)
	var bar_width = player.health * mana_per_pixel
	
	$Bar.region_rect = Rect2(29, 8, int(bar_width), 16)
	$Bar.position.x = 97.5 - (bar_width_max - bar_width)/float(2)

	
