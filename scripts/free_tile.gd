extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var teleController: TelekineticController = $TelekineticController

var maxSpeed = 300
var friction = 50

var framesStoodOn = 0
var playerStandingOn = false
var burnedOut = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("ActiveTile")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if teleController.is_selected and not burnedOut:
		incrementBurnout()
		# calculate direction to go
		var x = Input.get_axis("TelekineticLeft", "TelekineticRight")
		var y = Input.get_axis("TelekineticUp", "TelekineticDown")
		var dir: Vector2 = Vector2(x, y)
		velocity = dir * maxSpeed
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		elif is_on_floor() or velocity.is_zero_approx():
			if burnedOut:
				recover()
			else:
				animationPlayer.stop()
	move_and_slide()

func incrementBurnout():
	if burnedOut: return
	if playerStandingOn and not is_on_floor():
		framesStoodOn += 1
		if framesStoodOn >= 60:
			animationPlayer.play("shake")
		if framesStoodOn >= 120:
			triggerBurnout()
	elif is_on_floor():
		framesStoodOn = 0
		animationPlayer.stop()

func triggerBurnout():
	framesStoodOn = 0
	burnedOut = true
	teleController.set_selected(false)
	teleController.set_enabled(false)
	sprite.play("InactiveTile")
	
func recover():
	teleController.set_enabled(true)
	burnedOut = false
	velocity = Vector2.ZERO
	sprite.play("ActiveTile")
	animationPlayer.stop()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == Player.floor_area_name:
		playerStandingOn = false
