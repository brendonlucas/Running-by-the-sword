extends Area

var camera
var player
var tocou

func _ready():
	camera = get_parent().get_parent().get_node("AnimationPlayer")
	player = get_parent().get_parent().get_node("player/Player")
	
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and tocou != true:
			tocou = true
			camera.play("reset_cam")
			player.invert_controls(1)
			
			
			#var c1 = Color("#ffb2d90a")
			#espiral.material_override.albedo_color = new_color
			#print(espiral.name)
			


