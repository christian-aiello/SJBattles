extends Node

var door_entered = null
var enemy_encountered = 10000

var player_level: = 1
var player_xp: = 0
var position_x = 0
var position_y = 0
var direction = Vector2(1, 0)
var health = 2*player_level + 28
var mana = 100
var current_level_xp = 0
var current_level_total_xp = 100

var enemies_beaten = [0,0,0,0,0,0,0,0]

var levels = [100, 150, 200, 300, 400, 550, 700, 900, 1100, 1300, 
1550, 1800, 2050, 2350, 2650, 3000, 3350, 3700, 4100, 4500, 
4950, 5350, 5850, 6350, 6850, 7350, 7900, 8450, 9050, 9650, 
10250, 10900, 11550, 12250, 12950, 13650, 14400, 15150, 15950, 16750, 
17550, 18400, 19250, 20100, 21000, 21900, 22850, 23800, 24750, 25750, 
26750, 27800, 28850, 29900, 31000, 32100, 33250, 34400, 35550, 36750, 
37950, 39150, 40400, 41650, 42950, 44250, 45550, 46900, 48250, 49650, 
51050, 52450, 53900, 55350, 56800, 58300, 59850, 61350, 62900, 64500, 
66100, 67700, 69300, 70950, 72650, 74350, 76050, 77750, 79500, 81300, 
83050, 84850, 86700, 88550, 90400, 92300, 94200, 96100, 98050, 100000]

func level_calculation():
	var xp = player_xp
	for i in range(0, 100):
		if (xp - levels[i] < 0):
			player_level = i + 1
			current_level_xp = xp
			current_level_total_xp = levels[i]
			break
		else:
			xp -= levels[i]
	
	
	
