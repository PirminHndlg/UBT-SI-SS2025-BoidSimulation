# Assets for creatures and nature models are made by QuaterniusDev (https://quaternius.com) which are shared under the
# CC0 1.0 Universal License (CC0 1.0) Public Domain Dedication (https://creativecommons.org/publicdomain/zero/1.0/)

extends Node3D
@export var max_initial_speed: float = 0.00005
@export var velocity: Vector3 = Vector3.ZERO
func _ready() -> void:
	# Set up Animation
	var flying_anim = $Pigeon/AnimationPlayer2.get_animation("flying_anims/flying")
	flying_anim.loop = true
	$Pigeon/AnimationPlayer2.play("flying_anims/flying")
	var speed = randf_range(0.0, max_initial_speed)
	velocity*=speed
	look_at(position+velocity)
	return
	

func _physics_process(_delta: float) -> void:
	position+=velocity
	pass
