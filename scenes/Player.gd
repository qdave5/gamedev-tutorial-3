extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed = 400
export (int) var jump_speed = -600
export (int) var dash_multiplier = 2
export (int) var GRAVITY = 1200

export (bool) var can_double_jump = true

const IDLE = 'idle'
const IS_MOVING = 'is_moving'
const IS_CROUCHING = 'is_crouching'
const DASH = 'dash'
const JUMP = 'jump'

const UP = Vector2(0,-1)

var velocity = Vector2()
var direction : Vector2 = Vector2.ZERO # for animation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	velocity.x = 0
	if is_on_floor():
		can_double_jump = true
		if Input.is_action_pressed("ui_crouch"):
			$Sprite.frame = 3
			speed = 200
		else:
			$Sprite.frame = 0
			speed = 400
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
		elif can_double_jump:
			velocity.y = jump_speed
			can_double_jump = false
	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
		velocity.x -= speed
	if Input.is_action_pressed("ui_dash"):
		velocity.x *= dash_multiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)
