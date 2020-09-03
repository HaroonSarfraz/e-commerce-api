json.extract! line_item, :id, :quantity, :created_at, :updated_at
json.price line_item.cost&.to_s
json.total line_item.total_cost&.to_s

json.image line_item.product.image&.url
json.product_id line_item.product.id
json.product_name line_item.product.name
