json.extract! product, :id, :name, :description, :category_id, :inventory, :created_at, :updated_at
json.image product.image&.url
json.price product.price&.to_s
