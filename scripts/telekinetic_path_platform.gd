extends Path2D

@onready var animBody = $AnimatableBody2D
@onready var sprite = $AnimatableBody2D/Sprite2D
@onready var marker = $AnimatableBody2D/Marker
@onready var teleController: TelekineticController = $AnimatableBody2D/TelekineticController
@onready var line: Line2D = $Line2D

# to set up:
# instantiate this scene
# define a Curve2D in the inspector of the scene node
@onready var pathFollow: PathFollow2D = $PathFollow2D
@export var speed: int = 100
@export var loop: bool = false
@export var returnToOriginalLocation: bool = false
@export var returnToOriginalLocationSpeed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleController.addControl("Right Arrow", "Move platform along rail")
	teleController.addControl("Left Arrow", "Move platform backwards along rail")
	pathFollow.loop = loop
	if curve:
		var points: PackedVector2Array = curve.get_baked_points()
		line.points = points
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if teleController.is_selected:
		var direction: float = Input.get_axis("TelekineticLeft", "TelekineticRight")
		pathFollow.progress += speed * delta * direction
	elif returnToOriginalLocation and pathFollow.progress != 0:
		pathFollow.loop = false
		pathFollow.progress -= returnToOriginalLocationSpeed * delta
		pathFollow.loop = loop

func _on_telekinetic_controller_on_set_enabled(is_enabled: bool) -> void:
	if is_enabled:
		sprite.modulate = TelekineticController.spriteModulationColor
	else:
		sprite.modulate = Color("ffffff")
		
