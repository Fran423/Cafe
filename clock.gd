extends Sprite2D

var initial_time : Array = [0,12]
var segundero_moving : bool = false
var minutero_tween : Tween = null

func update_clock(time : float): #in seconds
	var seconds = int(time+initial_time[0])
	while seconds > 60:
		seconds -= 60
	var rotation_segundero : float = remap(seconds,0,60,0,360)
	var minutes = int(time/60+initial_time[1])
	var rotation_minutero = remap(minutes,0,12,0,360)
	$Minutero.rotation = deg_to_rad(rotation_minutero)
	$Label.text = str("%02d"%int(minutes),':',"%02d"%int(seconds))
	if !segundero_moving:
		print('hi')
		segundero_moving = true
		var segundero_tween = create_tween()
		segundero_tween.tween_property($Segundero,'rotation',deg_to_rad(rotation_segundero),0.5)
		await get_tree().create_timer(0.5,false).timeout
		segundero_moving = false
