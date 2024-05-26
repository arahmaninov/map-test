extends Node2D


@onready var map: Node2D = $map
@onready var regions_image: Sprite2D = $regions

@onready var hover_label: Label = $UI/HoverLabel
@onready var click_label: Label = $UI/ClickLabel


func _ready() -> void:
	setup_signals()
	load_regions()


func setup_signals() -> void:
	EventBus.country_hover.connect(_on_country_hover)
	EventBus.country_clicked.connect(_on_country_clicked)


func load_regions() -> void:
	var image = regions_image.get_texture().get_image()
	
	regions_image.texture = image
	
	var pixel_colors: Dictionary = get_pixel_colors(image)
	var regions: Dictionary = import_json("res://assets/regions.txt")
	
	for region_color in regions:
		var region: Node = load("res://scenes/region_area.tscn").instantiate()
		region.region_name = regions[region_color]
		region.set_name(region_color)
		map.add_child(region)
		
		var polygons: Array[PackedVector2Array] = get_polygons(image, region_color, pixel_colors)
		for polygon: PackedVector2Array in polygons:
			var region_collision: CollisionPolygon2D = CollisionPolygon2D.new()
			var region_polygon: Polygon2D = Polygon2D.new() 
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision)
			region.add_child(region_polygon)


#Store color of every pixel of the image
func get_pixel_colors(img: Image) -> Dictionary:
	var pixel_colors_dict: Dictionary = {}
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var pixel_color: String = "#%s" %img.get_pixel(int(x), int(y)).to_html(false)
			if pixel_color not in pixel_colors_dict:
				pixel_colors_dict[pixel_color] = []
			pixel_colors_dict[pixel_color].append(Vector2(x, y))
	
	return pixel_colors_dict


#Create polygons for area2d of the region
func get_polygons(img: Image, region_color, pixel_colors: Dictionary) -> Array[PackedVector2Array]:
	var targetImage: Image = Image.create(
		img.get_size().x, 
		img.get_size().y,
		false,
		Image.FORMAT_RGBA8
		)
	
	for value in pixel_colors[region_color]:
		targetImage.set_pixel(value.x, value.y, "#fffff8")
	
	var bitmap: BitMap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	var polygons: Array[PackedVector2Array] = bitmap.opaque_to_polygons(
		Rect2(Vector2(0, 0), bitmap.get_size()),
		0.1
		)
	
	return polygons


#Import JSON and convert it to dictionary
func import_json(filepath: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		printerr("Failed to open file: " + filepath)
		return {}


func _on_country_hover(country_name: String) -> void:
	hover_label.text = country_name


func _on_country_clicked(country_name: String) -> void:
	click_label.text = country_name + " rules!"
