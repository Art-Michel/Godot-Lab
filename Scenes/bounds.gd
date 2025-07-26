extends StaticBody2D

@export var top: CollisionShape2D
@export var left: CollisionShape2D
@export var right: CollisionShape2D
@export var bot: CollisionShape2D

func _ready():
	var windowsize: Vector2 = DisplayServer.window_get_size()
	#var windowsize: Vector2 = DisplayServer.screen_get_size()
	var line: SegmentShape2D = right.shape
	var line2: SegmentShape2D = bot.shape
	line.a.x = windowsize.x
	line.a.y = 9000
	
	line.b.x = windowsize.x
	line.b.y = 0

	line2.a.x = 0
	line2.a.y = windowsize.y
	
	line2.b.x = 9000
	line2.b.y = windowsize.y
