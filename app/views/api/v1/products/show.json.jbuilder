json.extract! @product, :id, :name, :description, :inventory, :created_at, :updated_at

json.image @product.image&.url
json.price @product.price&.to_s

json.category do
  json.id @product.category.id
  json.name @product.category.name
  json.description @product.category.description
end
