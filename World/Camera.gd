extends Camera2D

var shake = 0
var Main := ResourceLoader.MainInstances as MainInstances

onready var timer = $Timer

func _ready():
	Main.WorldCamera = self
	var err = Events.connect("add_screenshake", self, "_on_Events_add_screenshake")
	if err:
		print(err)

func queue_free():
	Main.WorldCamera = null
	.queue_free()

func _process(_delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func screenshake(amount, duration):
	shake = amount
	timer.start(duration)

func _on_Timer_timeout():
	shake = 0

func _on_Events_add_screenshake(amount, duration):
	screenshake(amount, duration)
