extends CanvasLayer

var p = PlayerVariables

signal send_enemy_stats
signal send_back_hero_stats

#animation signals
signal hero_default
signal hero_attack
signal hero_item
signal enemy_default
signal enemy_attack

signal enemy_setup #gets the enemy ready

var enemy_identity # determines which enemy it is

var hero_animation #checks if the hero needs the idle animation

var hero_max_health: = 2*PlayerVariables.player_level + 28
var hero_health = int(PlayerVariables.health)

var enemy_health
var enemy_name
var enemy_max_health

#these two variables may be coming from a signal later
var hero_damage_base: = 5000
var enemy_damage_base

var damage
const COOKIE_VALUE: = 10

const XP_PER_LEVEL: = 200

var rng = RandomNumberGenerator.new() #randomizer


	
#if the player wins the battle, checks if that is the last battle that they need to win
func check_if_game_beaten():
	var game_beaten = true
	
	for num in PlayerVariables.enemies_beaten:
		if num == 0:
			game_beaten = false
			break
	
	if game_beaten == true:
		get_tree().change_scene("res://scenes/WinScreen.tscn")
		

#constanlty checking if we need the idle or attack animation
func _process(delta: float) -> void:
	#plays the default animation
	if hero_animation == "default":
		emit_signal("hero_default")
		
	#Plays the attack animation
	elif hero_animation == "attack":
		emit_signal("hero_attack")
		

func _ready() -> void:
	enemy_identity = PlayerVariables.enemy_encountered
	emit_signal("enemy_setup", enemy_identity)
	
	$EnemyLevelLabel.text = "Level: " + str(enemy_identity+1)
	
	
	$Hero/Player/AnimationPlayer.stop()
	
	$FightMusic1.play() #starts playing the music
	
	hero_animation = "default"
	emit_signal("enemy_default")
	emit_signal("sendEnemyVars", enemy_identity)
	
	#setting the variables based on which enemy it is
	enemy_max_health = int([30,35,40,45,50,55,60,80][enemy_identity])
	enemy_health = enemy_max_health
	enemy_name = str(["Ms. DiGasbarro", "Ms. Gidaro", "Ms. Mauti", "Ms. Valeri", "Mr. Binelli", "Mr. Lionti", "Mr. Pantaleo", "Mr. Tauro"][enemy_identity])
	enemy_damage_base = int([4,5,6,7,8,10,12,15][enemy_identity])
	
	rng.randomize() #giving the randomizer randomness
	update_health() #sets the healths
	
	hero_turn()
	

func back_to_map():
#determining where to place the user when the battle is done
	if hero_health == 0:
		PlayerVariables.health = 1
	else:
		PlayerVariables.health = hero_health
	if enemy_identity == 0:
		PlayerVariables.position_x = -64
		PlayerVariables.position_y = -811
		get_tree().change_scene("res://scenes/floor1.tscn")
	if enemy_identity == 1:
		PlayerVariables.position_x = -64
		PlayerVariables.position_y = -691
		get_tree().change_scene("res://scenes/floor1.tscn")
	if enemy_identity == 2:
		PlayerVariables.position_x = 210
		PlayerVariables.position_y = -130
		get_tree().change_scene("res://scenes/floor2.tscn")
	if enemy_identity == 3:
		PlayerVariables.position_x = -430
		PlayerVariables.position_y = -68
		get_tree().change_scene("res://scenes/floor3.tscn")
	if enemy_identity == 4:
		PlayerVariables.position_x = -460
		PlayerVariables.position_y = -150
		get_tree().change_scene("res://scenes/floor3.tscn")
	if enemy_identity == 5:
		PlayerVariables.position_x = -735
		PlayerVariables.position_y = -1039
		get_tree().change_scene("res://scenes/floor1.tscn")
	if enemy_identity == 6:
		PlayerVariables.position_x = -260
		PlayerVariables.position_y = -188
		get_tree().change_scene("res://scenes/floor2.tscn")
	if enemy_identity == 7:
		PlayerVariables.position_x = -805
		PlayerVariables.position_y = -158
		get_tree().change_scene("res://scenes/floor1.tscn")
	

#function to show/hide the moves for the hero
func show_moves(should_show):
	if should_show:
		$AttackButton.show()
		$ItemButton.show()
	else:
		$AttackButton.hide()
		$ItemButton.hide()
		

#updates the health bars and xp bar of the players
func update_health():
	$HeroHealthLabel.text = str(hero_health) + "/" +str(hero_max_health)
	$XpLabel.text = "Level: " + str(PlayerVariables.player_level) + "   XP: " + str(p.current_level_xp) + '/' + str(p.current_level_total_xp)
	$EnemyHealthLabel.text = str(enemy_health) + "/" + str(enemy_max_health)
	


#function to check if the game's done
func is_game_done():
	if enemy_health <= 0:
		#displaying ending info
		var xp_won = int((100+enemy_identity*50) * rng.randf_range(0.75, 1.25))
		$PromptLabel.text = "Hero Wins!"
		yield(get_tree().create_timer(1), 'timeout')
		p.player_xp += xp_won
		p.level_calculation()
		update_health()
		$PromptLabel.text = "You won " + str(xp_won) + " xp!"
		yield(get_tree().create_timer(1), 'timeout')
		p.enemies_beaten[enemy_identity] = 1
		
		check_if_game_beaten() #checks if the whole game has been beaten
		
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		$Enemy.hide()
		show_moves(false)
		$FightMusic1.stop()
		
		
		#dealing with the experience points
		#reward for winning based on the enemy_identity
		
		p.level_calculation()
			
		update_health()
		#emit_signal("send_back_hero_stats", hero_level, hero_xp)
		back_to_map()
		
		return true #making sure the script knows that the game is over
		
		
		
	if hero_health <= 0:
		#displaying ending info
		$PromptLabel.text = enemy_name + " Wins!"
		
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		$Hero.hide()
		show_moves(false)
		$FightMusic1.stop()
		back_to_map()
		
		return true
	
	return false



#function for starting enemy's turn
func enemy_turn():
	#pikachu takes damage
	damage = enemy_damage_base + rng.randi_range(-2, 2)
	hero_health -= damage
	hero_health = max(hero_health, 0) #making sure it doesnt show a health below 0
	
	#sets a delay
	$Timer.start()
	yield($Timer, "timeout")
	
	#updating the interface
	$PromptLabel.text = enemy_name + " Dealt " + str(damage) + " Damage!"
	#$Punch.play() --> add this back in when we get attack animations
	
	emit_signal("enemy_attack")
	
	end_turn("Enemy")
	

#function for starting hero's turn
func hero_turn():
	$PromptLabel.text = "Cookies Remaining: " + str(PlayerVariables.num_cookies)


#gets the interface ready for the start of a turn, person is for the person who's turn is ending
func end_turn(person):
	if person == "Hero":
		update_health()
		show_moves(false)
		
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		#checks if the game is done
		if not is_game_done():
			enemy_turn()
		
	elif person == "Enemy":
		update_health()
	
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		#checks if the game is done
		if not is_game_done():
			show_moves(true)
			hero_turn()
			
			
	#puts back the default animations	
	hero_animation = "default"
	emit_signal("enemy_default")
	
	
#function for pikachu attacking
func _on_AttackButton_pressed() -> void:
	show_moves(false)
	#enemy takes damage
	damage = hero_damage_base + rng.randi_range(-2, 2)
	enemy_health -= damage
	enemy_health = max(enemy_health, 0)
		
	#updating the interface
	$PromptLabel.text = "Hero Dealt " + str(damage) + " Damage!"
	#$Punch.play() --> maybe add this in when we get more attacks
	
	#plays one iteration of the attack animation
	hero_animation = "attack"
	$AttackAnimationDelay.start()
	yield($AttackAnimationDelay, "timeout")
	hero_animation = "default"
	
	end_turn("Hero")


func _on_ItemButton_pressed() -> void:
	#if you still have potions
	if PlayerVariables.num_cookies > 0:
		PlayerVariables.num_cookies -= 1
		hero_health += COOKIE_VALUE
		
		#making sure we dont go over the max health with a potion
		if hero_health > hero_max_health:
			hero_health = hero_max_health
		
		$PromptLabel.text = "Hero Used A Cookie!"
		#$Heal.play() #lesson learned: .wav files play once, .mp3 files play indefinitely --> ADD BACK IN THE SOUNDS
		emit_signal("hero_potion")
		end_turn("Hero")
	#if you are out of potions
	else:
		$PromptLabel.text = "You don't have anymore cookies!"
		
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		hero_turn()

"""
#takes the variables from pikachu and gives them to the main script
func _on_hero_send_stats(hero_level_stored, hero_xp_stored) -> void:
	hero_level = hero_level_stored
	hero_xp = hero_xp_stored
"""


