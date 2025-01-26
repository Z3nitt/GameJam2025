extends CanvasLayer

@onready var collectible_label = $MarginContainer/VBoxContainer/HBoxContainer/Control/CollectibleLabel

func _process(delta: float) -> void:
	%ScoreLabel.text = "SCORE: " + str(GameManager.score_points)

func _ready():
	CollectibleManager.on_collectible_award_received.connect(on_collectible_award_received)

func _physics_process(delta):
	pause_game()

func on_collectible_award_received(total_award : int):
	collectible_label.text = str(total_award)


func _on_pause_texture_button_pressed() -> void:
	GameManager.pause_game()

func pause_game():
	if Input.is_action_just_pressed("escape"):
		GameManager.pause_game()
		
