# Assets for creatures and nature models are made by QuaterniusDev (https://quaternius.com) which are shared under the
# CC0 1.0 Universal License (CC0 1.0) Public Domain Dedication (https://creativecommons.org/publicdomain/zero/1.0/)

extends Node3D
@export var max_initial_speed: float = 0.00005
@export var velocity: Vector3 = Vector3.ZERO
@export var boundary: Vector3 = Vector3(60,60,60)
@export var camera:Camera3D = null

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
	if (abs(position.x) > boundary.x):
		velocity.x = -velocity.x
	if (abs(position.y) > boundary.y or position.y < 0.5):
		velocity.y = -velocity.y
	if (abs(position.z) > boundary.z):
		velocity.z = -velocity.z
	pass

func is_visible_from_camera(camera: Camera3D, object: Node3D) -> bool:
	if(camera!=null):
		var obj_pos = object.global_transform.origin
		var projected = camera.unproject_position(obj_pos)
		return (
			projected.z > 0.0 and  # in front of camera
			projected.x >= 0.0 and projected.x <= 1.0 and
			projected.y >= 0.0 and projected.y <= 1.0
		)
	print_debug("Camera visibility check with null camera")
	return false
