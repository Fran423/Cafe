extends Sprite2D

var initial_time : Array = [0,12]
var segundero_time_left : float = 1
var minutero_time_left : float = 60

func update_clock(time : float): #in seconds
	var seconds = int(time+initial_time[0])
	var rotation_minutero = remap(seconds,0,720,0,360)
	var rotation_segundero : float = remap(seconds,0,60,0,360)
	while seconds > 60:
		seconds -= 60
	
	segundero_time_left -= get_process_delta_time()
	minutero_time_left -= get_process_delta_time()
	var minutes = int(time/60+initial_time[1])
	$Label.text = str("%02d"%int(minutes),':',"%02d"%int(seconds))
	if segundero_time_left <= 1:
		segundero_time_left += 1
		var segundero_tween = create_tween()
		segundero_tween.tween_property($Segundero,'rotation',deg_to_rad(rotation_segundero),0.5).set_trans(Tween.TRANS_ELASTIC)
	if minutero_time_left <= 0:
		minutero_time_left += 60
		var minutero_tween = create_tween()
		minutero_tween.tween_property($Minutero,'rotation',deg_to_rad(rotation_minutero),0.5).set_trans(Tween.TRANS_ELASTIC)
