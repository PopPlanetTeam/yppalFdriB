extends Area2D

@export var aperture: int
var offset: int
signal hit
signal scored

func _ready():
	offset = $Sprite2D.texture.get_height() / 2
	#change_aperture()
	
func change_aperture():
	$Sprite2D.position.y = offset + aperture / 2
	$Sprite2D2.position.y = -(offset + aperture / 2)
	$CollisionShape2D.position.y = offset + aperture / 2
	$CollisionShape2D2.position.y = -(offset + aperture / 2)

func _on_body_entered(body):
	hit.emit()

func _on_score_area_body_entered(body):
	scored.emit()
