extends KinematicBody

var MOVE_SPEED = 7
var JUMP_FORCE = 11
const GRAVITY = 0.98
const MAX_FALL_SPEED = 20
var y_velo = 0
const H_LOOK_SENS = 0.6
const V_LOOK_SENS = 0.4
var velo_pista = 7


var centro =  true
var Type_controls = 1
var jump_active = true
var animation
var animate_current
var block_jump = false
var is_moving = true
var block_move = false
var active_jump_super = false
var death = false
var ja_morreu = false

func _ready():
	animation = get_node("AnimationPlayer")
	
	
func player_death():
	death = true
	block_move = true
	is_moving = false
	
func block_moving():
	is_moving = false
	
func block_moves(type):
	block_move = type
	
func super_jump(forca):
	JUMP_FORCE = forca
	active_jump_super = true
	
func block_moves_cam_down(type):
	block_jump = type
	if type == true:
		animation.play("jump")
	elif type == false:
		animation.play("jump_fall")
		
func change_speed(speed):
	velo_pista = velo_pista * speed

func invert_controls(type):
	Type_controls = type
	
func _physics_process(delta):
	animate_current = animation.current_animation
	
	var roll = false
	var just_jumped = false
	var grounded = is_on_floor()

	if animate_current == "anm_00000008":
		roll = true
	else:
		roll = false
	var move_vec = Vector3()
	
	if death and !ja_morreu:
		ja_morreu = true
		animation.play("anm_00000001")
		
	if !block_move and !block_jump and Input.is_action_just_pressed("traz"):
		roll = true
		animation.play("anm_00000008")
		
	if !block_move and Type_controls == 1 and Input.is_action_pressed("direita"):
		move_vec.z -= 1
		
	if !block_move and Type_controls == 1 and Input.is_action_pressed("esquerda"):
		move_vec.z += 1

	if !block_move and Type_controls == 2 and Input.is_action_pressed("direita"):
		move_vec.z += 1

	if !block_move and Type_controls == 2 and Input.is_action_pressed("esquerda"):
		move_vec.z -= 1

	if !block_move and Type_controls == 3 and Input.is_action_pressed("direita"):
		move_vec.x += 1
	
	if !block_move and Type_controls == 3 and Input.is_action_pressed("esquerda"):
		move_vec.x -= 1
		
	if !block_move and !block_jump and !roll and velo_pista == 7 and is_moving and is_on_floor() and animate_current != "jump_fall":
		animation.play("anm_02076002")
	
	if !block_move and !block_jump and !roll and velo_pista != 7 and is_moving and is_on_floor() and animate_current != "jump_fall":
		animation.play("anm_02076008")
	
	if !block_move and !block_jump and jump_active and grounded and Input.is_action_just_pressed("pulo") or active_jump_super:
		just_jumped = true
		y_velo = JUMP_FORCE
		if active_jump_super:
			animation.play("anm_00070190")
		else:
			animation.play("anm_00000008")
	
	move_vec *= MOVE_SPEED
	move_vec.z
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0, 1, 0))
	y_velo -= GRAVITY

	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
	if active_jump_super:
		active_jump_super = false
		JUMP_FORCE = 11
