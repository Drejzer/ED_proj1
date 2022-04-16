extends Panel

signal generate_table(cat_count)

export(int) var category_count=2

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_button_up() -> void:
	emit_signal("generate_table",category_count)
	self.visible=false


func _on_LineEdit_value_changed(value: float) -> void:
	category_count=int(value)
