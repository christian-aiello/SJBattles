extends CanvasLayer

var p = PlayerVariables
const bar_width_max = 150

func _on_Player_player_stats_changed(var player):
	var xp_per_pixel = float(bar_width_max) / float(p.current_level_total_xp)
	var bar_width = p.current_level_xp * xp_per_pixel
	
	$Level.rect_size.x = int(floor(bar_width))
	$Level_Text.text = 'Level ' + str(p.player_level)
	$XP_Text.text = str(p.current_level_xp) + '/' + str(p.current_level_total_xp) + ' XP'
