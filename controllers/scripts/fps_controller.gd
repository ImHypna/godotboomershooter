extends CharacterBody3D

@export var SPEED_DEFAULT : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export var MOUSE_SENSITIVITY : float = 0.5
@export_range(5,10,0.1)	var CROUCH_SPEED: float = 2.0
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CROUCH_SHAPECAST: Node3D
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer

var _speed: float = 5.0
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3


var _is_crouching : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent) -> void:
	
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
func _input(event):
	if event.is_action_pressed("crouch"):
		toggle_crouch()
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
func _update_camera(delta):
	
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0
	
func _ready():

	Global.player = self

	# Get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	#CrouchShapeCast exception for characterbody3d node

	CROUCH_SHAPECAST.add_exception($".")

func _physics_process(delta):
	Global.debug.add_property("Movement Speed",_speed,-1)
	_update_camera(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !_is_crouching:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)

	move_and_slide()

func toggle_crouch():
	if _is_crouching == true and CROUCH_SHAPECAST.is_colliding()==false:
		ANIMATION_PLAYER.play("Crouch",0,-CROUCH_SPEED)
		set_movement_speed("default")
	elif _is_crouching == false:
		ANIMATION_PLAYER.play("Crouch",0,CROUCH_SPEED,true)
		set_movement_speed("crouching")
	

func set_movement_speed(state:String):
	match state:
		"default":
			_speed = SPEED_DEFAULT
		"crouching":
			_speed = CROUCH_SPEED


func _on_animation_player_animation_started(anim_name:StringName) -> void:
	_is_crouching = !_is_crouching
