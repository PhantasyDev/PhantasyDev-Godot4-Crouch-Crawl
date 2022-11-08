extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var lookSens = 6
var minLookAngle = -75
var maxLookAngle = 75
var mouseDelta = Vector2()
var playerRef
var cameraLock = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	playerRef = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSens * delta
	
	rotate_x(deg_to_rad(-1 * rot.x))
	rotation.x = clamp(rotation.x, deg_to_rad(minLookAngle), deg_to_rad(maxLookAngle))
	
	playerRef.rotate_y(deg_to_rad((-1 * rot.y)))
#		playerRef.rotation.y -= rot.y
	mouseDelta = Vector2()
