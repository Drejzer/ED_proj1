extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var categories=[]

onready var MistakeMatrix:GridContainer
onready var Parameters:TabContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MistakeMatrix=$"TabContainer/Macierz Pomyłek/HBoxContainer/VBoxContainer/Grid"
	Parameters=$"TabContainer/Wskaźniki/VBoxContainer/TabContainer"
	pass # Replace with function body.


func _on_category_name_changed(text,id):
	categories[id]=text
	MistakeMatrix.get_child((id+1)*(categories.size()+1)).text=text

func calc_total_correctness():
	var siz=categories.size()
	var ok:=0
	var total:=0
	for x in (siz+1):
		if x!=0:
			for y in (siz+1):
				if(y>0):
					if x==y:
						ok+=MistakeMatrix.get_child((y)*(siz+1)+x).value
					total+=MistakeMatrix.get_child((y)*(siz+1)+x).value
	if total>0:
		var perc=round((float(ok)/float(total))*1000.0)/10.0
		$"TabContainer/Wskaźniki/VBoxContainer/HBoxContainer/val".text=str(perc)+"%"
	else:
		$"TabContainer/Wskaźniki/VBoxContainer/HBoxContainer/val".text="NAN"


func _on_PopupDialog_generate_table(cat_count) -> void:
	for x in cat_count:
		categories.append("cat"+str(x))
	MistakeMatrix.columns=cat_count+1
	for x in cat_count:
		var l:=LineEdit.new()
		l.text=categories[x]
		MistakeMatrix.add_child(l)
		l.connect("text_changed",self,"_on_category_name_changed",[x])
	for y in cat_count:
		var l:=Label.new()
		l.text=categories[y]
		MistakeMatrix.add_child(l)
		for x in cat_count:
			var val=SpinBox.new()
			val.min_value=0
			val.max_value=100000
			val.step=1
			MistakeMatrix.add_child(val)
			 

func _calc_traf_by_cat(n:int)->float:
	var siz=categories.size()+1
	var ok:=0
	var total:=0
	for x in siz:
		if x!=0:
			for y in siz:
				if(y>0):
					if (x==n+1 and y==n+1) or (x!=n+1 and y!=n+1):
						ok+=MistakeMatrix.get_child((y)*(siz)+x).value
					total+=MistakeMatrix.get_child((y)*(siz)+x).value
	if total>0:
		return round(ok*1000.0/total)/10.0
	else:
		 return -1.0

func _calc_spec_by_cat(n:int)->float:
	var siz=categories.size()+1
	var ok:=0
	var total:=0
	for x in siz:
		if x!=0:
			for y in siz:
				if(y>0):
					if (x==n+1 and y!=n+1) or (x!=n+1 and y==n+1):
						total+=MistakeMatrix.get_child((y)*(siz)+x).value
					elif (x!=n+1 and y!=n+1):
						ok+=MistakeMatrix.get_child((y)*(siz)+x).value
						total+=MistakeMatrix.get_child((y)*(siz)+x).value
	if total>0:
		return round(ok*1000.0/total)/10.0
	else:
		 return -1.0

func _calc_sens_by_cat(n:int)->float:
	var siz=categories.size()+1
	var ok:=0.0
	var fneg:=0.0
	for x in siz:
		if(x>0):
			if (x==n+1):
				ok+=MistakeMatrix.get_child((x)*(siz)+n+1).value
			else:
				fneg+=MistakeMatrix.get_child((x)*(siz)+n+1).value
	if ok+fneg>0:
		return round(ok*1000.0/(ok+fneg))/10.0
	else:
		 return -1.0

func _on_Button_button_up() -> void:
	calc_total_correctness()
	for c in Parameters.get_children():
		c.queue_free()
	yield(get_tree(),"idle_frame")
	for n in categories.size():
		var par:=VBoxContainer.new()
		par.name=categories[n]
		var ltraf=Label.new()
		ltraf.text= "Trafność: "
		var lspec=Label.new()
		lspec.text="Specyficzność: "
		var lsens=Label.new()
		lsens.text="Czułość: "
		par.add_child(ltraf)
		par.add_child(lspec)
		par.add_child(lsens)
		var val = _calc_traf_by_cat(n)
		if val>=0:
			ltraf.text+=" "+str(val)+"%"
		else:
			ltraf.text+=" NAN"
		val=_calc_sens_by_cat(n)
		if val>=0:
			lsens.text+=" "+str(val)+"%"
		else:
			lsens.text+=" NAN"
		val = _calc_spec_by_cat(n)
		if val>=0:
			lspec.text+=" "+str(val)+"%"
		else:
			lspec.text+=" NAN"
		
		Parameters.add_child(par)
