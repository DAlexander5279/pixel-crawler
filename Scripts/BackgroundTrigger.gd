extends Area2D

# Reference to the two ParallaxBackground nodes
@export var parallax_background1 : ParallaxBackground
@export var parallax_background2 : ParallaxBackground

func _on_area_entered(area):
	if area.name == "player":  # Replace "Player" with the name of your player node
		switch_background()

func switch_background():
	# Turn off the first background and turn on the second background
	parallax_background1.visible = false
	parallax_background2.visible = true



