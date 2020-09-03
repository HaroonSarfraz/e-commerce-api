json.extract! @order, :id, :created_at, :updated_at
json.total_amount @order.total_amount&.to_s
json.total_items_amount @order.total_items_amount.to_s

json.line_items @line_items, partial: 'line_item', as: :line_item

json.shipping_address @address, partial: 'api/v1/customer/shipping_addresses/address', as: :address

json.card @card, partial: 'api/v1/customer/cards/card', as: :card
