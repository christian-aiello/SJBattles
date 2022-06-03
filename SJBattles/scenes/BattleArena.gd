extends CanvasLayer



signal send_enemy_stats
signal send_back_hero_stats

#animation signals
signal hero_default
signal hero_attack
signal hero_item
signal enemy_default
signal enemy_attack

signal enemy_setup #gets the enemy ready

var enemy_identity: = 0 #may be changed later, but it determines which enemy it is

var hero_level
var hero_xp

const HERO_MAX_HEALTH: = 30 #this may be coming from a signal later
var hero_health: = HERO_MAX_HEALTH

var enemy_health
var enemy_name
var enemy_max_health

#these two variables may be coming from a signal later
const HERO_DAMAGE_BASE: = 5
const ENEMY_DAMAGE_BASE: = 5

var damage
var potions_remaining: = 3 #may be coming from a signal later
const POTION_VALUE: = 10

const XP_PER_LEVEL: = 100

var rng = RandomNumberGenerator.new() #randomizer


func _ready() -> void:
	emit_signal("hero_default")
	emit_signal("sendEnemyVars", enemy_identity)
	
	#setting the variables based on which enemy it is
	enemy_max_health = int([30, 25][enemy_identity])
	enemy_health = enemy_max_health
	enemy_name = str(["Steven", "Teacher"][enemy_identity])
	
	
	rng.randomize() #giving the randomizer randomness
	update_health() #sets the healths
	
	emit_signal("hero_default")
	emit_signal("enemy_default")
	
	hero_turn()
	

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
	$HeroHealthLabel.text = str(hero_health) + "/" +str(HERO_MAX_HEALTH)
	$XpLabel.text = "level: " + str(hero_level) + "   xp: " + str(hero_xp)
	$EnemyHealthLabel.text = str(enemy_health) + "/" + str(enemy_max_health)
	


#function to check if the game's done
func is_game_done():
	if enemy_health <= 0:
		#displaying ending info
		$PromptLabel.text = "Hero Wins!"
		$Enemy.hide()
		show_moves(false)
		
		
		
		#dealing with the experience points
		hero_xp += 150 #150 xp will be the reward for winning
		hero_level += int(hero_xp / XP_PER_LEVEL) #100xp will be one level
		hero_xp = hero_xp % XP_PER_LEVEL
		update_health()
		emit_signal("send_back_hero_stats", hero_level, hero_xp)
		
		return true #making sure the script knows that the game is over
		
	if hero_health <= 0:
		#displaying ending info
		$PromptLabel.text = enemy_name + " Wins!"
		$Hero.hide()
		show_moves(false)
		return true
	
	return false



#function for starting enemy's turn
func enemy_turn():
	#pikachu takes damage
	damage = ENEMY_DAMAGE_BASE + rng.randi_range(-2, 2)
	hero_health -= damage
	hero_health = max(hero_health, 0) #making sure it doesnt show a health below 0
	
	#sets a delay
	$Timer.start()
	yield($Timer, "timeout")
	
	#updating the interface
	$PromptLabel.text = enemy_name + " Attacked For " + str(damage) + " Damage!"
	#$Punch.play() --> add this back in when we get attack animations
	
	emit_signal("enemy_attack")
	
	end_turn("Enemy")
	

#function for starting hero's turn
func hero_turn():
	$PromptLabel.text = "Potions Remaining: " + str(potions_remaining)


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
	emit_signal("hero_default")
	emit_signal("enemy_default")
	
	
#function for pikachu attacking
func _on_AttackButton_pressed() -> void:
	#enemy takes damage
	damage = HERO_DAMAGE_BASE + rng.randi_range(-2, 2)
	enemy_health -= damage
	enemy_health = max(enemy_health, 0)
		
	#updating the interface
	$PromptLabel.text = "Hero Attacked For " + str(damage) + " Damage!"
	#$Punch.play() --> maybe add this in when we get more attacks
	emit_signal("hero_attack")
	end_turn("Hero")


func _on_ItemButton_pressed() -> void:
	#if you still have potions
	if potions_remaining > 0:
		potions_remaining -= 1
		hero_health += POTION_VALUE
		
		#making sure we dont go over the max health with a potion
		if hero_health > HERO_MAX_HEALTH:
			hero_health = HERO_MAX_HEALTH
		
		$PromptLabel.text = "Hero Used A Potion!"
		#$Heal.play() #lesson learned: .wav files play once, .mp3 files play indefinitely --> ADD BACK IN THE SOUNDS
		emit_signal("hero_potion")
		end_turn("Hero")
	#if you are out of potions
	else:
		$PromptLabel.text = "You don't have anymore potions!"
		
		#sets a delay
		$Timer.start()
		yield($Timer, "timeout")
		
		hero_turn()

#takes the variables from pikachu and gives them to the main script
func _on_hero_send_stats(hero_level_stored, hero_xp_stored) -> void:
	hero_level = hero_level_stored
	hero_xp = hero_xp_stored
