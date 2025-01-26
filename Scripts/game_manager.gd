extends Node

var main_menu_screen = preload("res://Scenes/main_menu.tscn")
var level_1 = preload("res://Scenes/nivel_1.tscn")
var pause_menu_screen = preload("res://Scenes/pause_menu.tscn")
var game_over_screen = preload("res://Scenes/gameover.tscn")

var score_points : int = 0

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.14, 0.05, 0.15, 1.00))

func start_game():
	if get_tree().paused:
		resume_game()
		return
	transition_to_scene(level_1.resource_path)
	
func exit_game():
	get_tree().quit()

func pause_game():
	get_tree().paused = true
	
	var pause_menu_screen_instance = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instance)

func resume_game():
	get_tree().paused = false

func main_menu():
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instance)

func game_over():
	var game_over_screen_instance = game_over_screen.instantiate()
	get_tree().get_root().add_child(game_over_screen_instance)

func transition_to_scene(scene_path):
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)
