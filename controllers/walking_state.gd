class_name WalkingPlayerState

extends State


@export var ANIMATION: AnimationPlayer
@export var TOP_ANIM_SPEED: float = 2.2


func enter() -> void:
    ANIMATION.play("Walking",-1.0,1.0)

func update(delta):
    set_scene_instance_load_placeholder(Global.player.velocity.length())
    if Global.player.velocity.length() == 0:
        transition.emit("IdleState")

func set_animation_speed(spd):
    var alpha = remap(spd,0.0,Global.player.SPEED_DEFAULT,0.0,1.0)
    ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED,alpha)

func _input(event):
    if event.is_action_pressed("sprint") and Global.player.is_on_floor():
        transition.emit("SprintingState")
    












# ------------------------------------------------------ÁREA DE LÓGICAS QUE DERAM ERRADO----------------------------------------------------
        #tentativa de JumpingState
        #if Global.player.is_on_floor() == false and Global.player.velocity.z.velocity > 0:
            #transition.emit("JumpingState")