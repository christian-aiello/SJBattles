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

var enemies_beaten = [0,0,0,0,0,0,0,0]
