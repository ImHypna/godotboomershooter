class_name WalkingPlayerState

extends State


func update(delta):
    if Global.player.velocity.length() == 0 and Global.player.is_on_floor():

        transition.emit("IdleState")














# ------------------------------------------------------ÁREA DE LÓGICAS QUE DERAM ERRADO----------------------------------------------------
        #tentativa de JumpingState
        #if Global.player.is_on_floor() == false and Global.player.velocity.z.velocity > 0:
            #transition.emit("JumpingState")