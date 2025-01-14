extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()
		return
	
	var controller = TelekineticSelector.getTelekineticNodeFromBody(body)
	if controller and controller.respawnLocation != Vector2.ZERO:
		body.position = controller.respawnLocation
		if body is CharacterBody2D: body.velocity = Vector2.ZERO
