# Assets for creatures and nature models are made by QuaterniusDev (https://quaternius.com) which are shared under the
# CC0 1.0 Universal License (CC0 1.0) Public Domain Dedication (https://creativecommons.org/publicdomain/zero/1.0/)
class_name birdoid_main

extends Node3D
var y_range = Vector2(5,30)
var x_range = Vector2(-20,20)
var z_range = Vector2(-20,20)

@onready var birds_root: Node3D = $Birds
@onready var camera_3d: Camera3D = $Camera3D

# 2e)
# Vector for goal point and get the timer node and the checkbox node
var goal_point = Vector3(0,0,0)
@onready var random_timer = 	get_node("RandomEventTimer")	#trigger: 1s
@onready var goal_enabled:CheckButton = get_node("RandomEventTimer/goal")

const BIRD = preload("res://scenes/bird.tscn")
func _ready() -> void:
	for i in range(randi_range(30,60)):
		var instance = BIRD.instantiate()
		instance.position =Vector3(randf_rangeV(x_range),randf_rangeV(z_range),randf_rangeV(y_range))
		birds_root.add_child(instance)
		instance.main=self
		print_debug("Spawned "+str(i)+" birdoid")
	
	# start timer, add trigger function _on_random_timer_timeout
	random_timer.start()
	random_timer.connect("timeout", Callable(self, "_on_random_timer_timeout"))
	
	pass
	
# trigger function for random timer
func _on_random_timer_timeout():
	# This gets called every second
	# with 70% chance new goal is defined
	if goal_enabled.button_pressed and randf() > 0.7:
		var rand_x = randi_range(x_range.x, x_range.y)
		var rand_y = randi_range(y_range.x, y_range.y)
		var rand_z = randi_range(z_range.x, z_range.y)
		goal_point = Vector3(rand_x, rand_y, rand_z)
		print_debug("New goal: "+str(goal_point))
		
	return
	
func _physics_process(_delta: float) -> void:
	pass
	
func randf_rangeV(range: Vector2)->float:
	return randf_range(range[0],range[1])
