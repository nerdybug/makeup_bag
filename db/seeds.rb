foos_items = [
	["roller lash", "mascara", "brown"],
	["hello flawless", "powder", "ivory"],
	["gotta glow", "lip tint", "perfect berry"],
	["naked ultra nourishing", "lip gloss", "beso"],
]

foos_items.each do |name, type_of_item, color|
	Item.create(name: name, type_of_item: type_of_item, color: color, user_id: 2)
end
