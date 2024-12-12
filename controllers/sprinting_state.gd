class_name Sprint_State extends State



@export var ANIMATION: AnimationPlayer
@export var TOP_ANIM_SPEED: float = 1.6

func enter()->void:
    ANIMATION.play("Sprinting",0.5,1.0)
    Global.player._speed = Global.player.SPEED_SPRINT


func update(delta)->void:
    set_animation_speed(Global.player.velocity.length())


func set_animation_speed(spd):
    var alpha = remap(spd,0.0,Global.player.SPEED_DEFAULT,0.0,1.0)
    ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED,alpha)


func _input(event) -> void:
    if event.is_action_released("sprint"):
        await ANIMATION.animation_finished
        transition.emit("WalkingState")