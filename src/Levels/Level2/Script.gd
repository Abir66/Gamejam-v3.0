extends Node2D

signal level_clear
signal set_charge
signal set_health
signal level_lost

var camera : Camera2D
var is_player_alive : bool

var dialogues = ["That wasn't supposed to happen.", "Why would you defy me?", "Was that instruction too complex?","Okay... Let's try some simple things first.",
"You are getting low on battery", "Charge yourself.", "Without charge, you cannot double-jump or shoot laser"]

var dialogue2_shown = false
var call_again = true

# Called when the node enters the scene tree for the first time.
func _ready():
	is_player_alive = true
	camera = $Player/Camera2D
	camera.make_current()
	$Player.charge = 60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if call_again : check_lose_condition()
	if call_again : check_win_condition()		

func _on_Player_set_charge(charge_value):
	emit_signal("set_charge", charge_value)


func _on_Player_set_health(health_value):
	emit_signal("set_health", health_value)


func _on_Player_player_died():
	is_player_alive = false
	if call_again  : check_lose_condition()
	

# Caution : Check if player is alive before using $Player
func check_win_condition():
	if is_player_alive :	
		if $Player.charge <= 5 :
			call_again = false
			emit_signal("level_clear")
			

func check_lose_condition():
	if not is_player_alive:
		call_again = false
		emit_signal("level_lost")


func _on_Player_tile_accept():
	call_again = false
	emit_signal("level_clear")


func _on_Player_tile_reject():
	$Player.kill()


func _on_Player_battery_picked():
	$Player.kill()
	

