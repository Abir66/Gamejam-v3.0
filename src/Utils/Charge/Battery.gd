extends Area2D


onready var anim_player: AnimationPlayer = $AnimationPlayer

export var charge: = 10


func _on_body_entered(body: PhysicsBody2D) -> void:
	picked()


func picked() -> void:
#	get_tree().change_scene("res://src/UI/GameOverMenu/GameOverMenu.tscn")
	PlayerData.charge += charge
	anim_player.play("picked")
