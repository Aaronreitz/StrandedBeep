extends CanvasLayer

@onready var game_manager: GameManager = %GameManager
@onready var coin_label: Label = %CoinLabel
@onready var time_label: Label = %TimeLabel
@onready var best_label: Label = %BestLabel


func _ready() -> void:
	var best_time = GameManager.load_best_time()
	best_label.text = "BEST " + GameManager.format_time(best_time) if best_time > 0.0 else ""


func _process(_delta: float) -> void:
	coin_label.text = "%d / %d" % [game_manager.score, game_manager.total_coins]
	time_label.text = GameManager.format_time(game_manager.elapsed_time())
