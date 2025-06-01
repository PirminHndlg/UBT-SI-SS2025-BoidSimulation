# Assets for creatures and nature models are made by QuaterniusDev (https://quaternius.com) which are shared under the
# CC0 1.0 Universal License (CC0 1.0) Public Domain Dedication (https://creativecommons.org/publicdomain/zero/1.0/)

extends Node3D
var y_range = Vector2(10,20)
var x_range = Vector2(-20,5)
var z_range = Vector2(-5,20)

@onready var birds_root: Node3D = $Birds

const BIRD = preload("res://scenes/bird.tscn")
func _ready() -> void:
	for i in range(randi_range(30,60)):
		var instance = BIRD.instantiate()
		instance.position =Vector3(randf_rangeV(x_range),randf_rangeV(z_range),randf_rangeV(y_range))
		birds_root.add_child(instance)
		var random_direction = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()
		instance.velocity = random_direction
		print_debug("Spawned "+str(i)+" birdoid")
	pass
	
func _physics_process(_delta: float) -> void:
	pass
	
func randf_rangeV(range: Vector2)->float:
	return randf_range(range[0],range[1])
