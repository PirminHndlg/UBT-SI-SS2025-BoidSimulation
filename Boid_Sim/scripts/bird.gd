# Assets for creatures and nature models are made by QuaterniusDev (https://quaternius.com) which are shared under the
# CC0 1.0 Universal License (CC0 1.0) Public Domain Dedication (https://creativecommons.org/publicdomain/zero/1.0/)

extends Node3D
@export var max_initial_speed: float = 0.00000001
@export var velocity: Vector3 = Vector3.ZERO
@export var goal_point: Vector3 = Vector3.ZERO

var x_bounds = Vector2(-20, 5)
var y_bounds = Vector2(10,20)
var z_bounds = Vector2(-5, 20)

# 2d)
# get the slider nodes
@onready var separation_slider = get_node("../../WorldEnvironment/Control/separation")
@onready var alignment_slider = get_node("../../WorldEnvironment/Control/alignment")
@onready var cohesion_slider = get_node("../../WorldEnvironment/Control/cohesion")

@export var neighbour_distance:float = 10.0
var neighbours: Array = []

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
	find_neighbours()
	
	var s_value = separation_slider.value
	var a_value = alignment_slider.value
	var c_value = cohesion_slider.value

	apply_boid_behaviour(s_value, a_value, c_value)
	
	# if bird is outside of boudary reverse direction
	position+=velocity
	if position.x < x_bounds.x or position.x > x_bounds.y:
		velocity.x = - velocity.x
	if position.y < y_bounds.x or position.y > y_bounds.y:
		velocity.y = - velocity.y
	if position.z <z_bounds.x or position.z > z_bounds.y:
		velocity.z = - velocity.z
		
	position.x = clamp(position.x, x_bounds.x, x_bounds.y)
	position.y = clamp(position.y, y_bounds.x, y_bounds.y)
	position.z = clamp(position.z, z_bounds.x, z_bounds.y)
	
	pass

func find_neighbours() -> void:
	neighbours.clear()
	for bird in get_parent().get_children():
		if bird!= self:
			var distance = position.distance_to(bird.position)
			if distance < neighbour_distance:
				neighbours.append(bird)
				
func apply_boid_behaviour(s_fac = 0.01, a_fac = 0.01, c_fac = 0.01) -> void:
	if neighbours.size() == 0:
		return
	var separation = Vector3.ZERO
	var alignment = Vector3.ZERO
	var cohesion = Vector3.ZERO
	
	for neighbour in neighbours:
		var diff = position - neighbour.position
		if diff.length() < 2.0:
			separation += diff
	
	for neighbour in neighbours:
		alignment += neighbour.velocity
	alignment /= neighbours.size()
	
	for neighbour in neighbours:
		cohesion += neighbour.position
	cohesion /= neighbours.size()
	cohesion = (cohesion - position)
	
	velocity += (separation * s_fac + alignment * a_fac + cohesion * c_fac)
	
	var max_speed = 1.0
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
