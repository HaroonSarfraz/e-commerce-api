class Category < ApplicationRecord
  include PgSearch::Model

  mount_uploader :image, ImageUploader

  pg_search_scope :search_for, against: %i[name description], using: { trigram: { threshold: 0.1 } }

  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
