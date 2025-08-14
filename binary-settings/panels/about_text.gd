extends RichTextLabel

@onready var about_text: RichTextLabel = %about_text

func _ready() -> void:
	var about_txt=[]
	OS.execute("bash",["-c","/usr/bin/kfetch"],about_txt)
	about_txt=about_txt[0]
	print (about_txt)
	about_text.add_text(about_txt)
