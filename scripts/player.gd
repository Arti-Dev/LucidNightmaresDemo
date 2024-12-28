extends CharacterBody2D

const MAX_SPEED = 300.0
const GROUND_FRICTION = MAX_SPEED * 0.3
const AIR_FRICTION = MAX_SPEED * 0.05
const AIR_CHANGE_SPEED = 10.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("PlayerJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("PlayerLeft", "PlayerRight")
	if direction:
		if is_on_floor():
			velocity.x = direction * MAX_SPEED
		else:
			velocity.x += direction * AIR_CHANGE_SPEED
			velocity.x = capSpeed(velocity.x, MAX_SPEED)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
	move_and_slide()


func capSpeed(speed: float, max: float) -> float:
	if abs(speed) < abs(max):
		return speed
	else:
		if speed < 0:
			return -max
		return max