extends Camera2D

@onready var area: Area2D = $TelekineticArea

# Queue of 2D bodies
var queue: Array = []
var selected_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Tab"):
		cycleQueue(true)
	elif Input.is_action_just_pressed("Q"):
		cycleQueue(false)
		

func _on_telekinetic_area_body_entered(body: Node2D) -> void:
	var teleNode = null
	for node in body.get_children():
		if node is TelekineticObject:
			teleNode = node
			break
	# add all objects, even if disabled
	if teleNode != null:
		insertNewNode(teleNode)
		if queue.size() == 1 and teleNode.is_enabled:
			teleNode.set_selected(true)
			selected_node = teleNode

func _on_telekinetic_area_body_exited(body: Node2D) -> void:
	# should instead store mappings of bodies to telekinetic nodes - later though
	var teleNode = null
	for node in body.get_children():
		if node is TelekineticObject:
			teleNode = node
			break

	if teleNode != null:
		teleNode.set_selected(false)
		removeNode(teleNode)
		
func cycleQueue(backwards: bool):
	var enabledQueue: Array = queue.filter(func(node): return node.is_enabled)
	if enabledQueue.size() == 0: return
	
	enabledQueue.sort_custom(sortByXGlobalPosition)
	
	var index = enabledQueue.find(selected_node)
	if index != -1:
		selected_node.set_selected(false)
		if backwards: index -= 1
		else: index += 1
	else:
		if backwards: index = enabledQueue.size() - 1
		else: index = 0
	
	if index == enabledQueue.size(): index = 0
	if index == -1: index = enabledQueue.size() - 1
	
	selected_node = enabledQueue[index]
	selected_node.set_selected(true)
	
func insertNewNode(node: TelekineticObject):
	# insert into the correct sorted location
	var body = node.get_parent()
	for i in range(queue.size()):
		if queue[i].get_parent().position.x > body.position.x:
			queue.insert(i, node)
			return
	queue.append(node)

func removeNode(node: TelekineticObject):
	var index = queue.find(node)
	if index != -1: queue.remove_at(index)
	
func sortByXGlobalPosition(node1: TelekineticObject, node2: TelekineticObject):
	var body1 = node1.get_parent()
	var body2 = node2.get_parent()
	if body1.global_position.x < body2.global_position.x:
		return true
	return false 
	
