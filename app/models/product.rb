class Product < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_for, against: :name, using: { trigram: { threshold: 0.1 } }
  mount_uploader :image, ImageUploader

  belongs_to :category

  has_one :sku, inverse_of: :product, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  delegate :inventory, :price, to: :sku, allow_nil: true

  after_create :create_stripe_product
  after_update :update_stripe_product

  private

  def create_stripe_product
    StripeServices::Product.new(id).create
  end

  def update_stripe_product
    StripeServices::Product.new(id).update
  end
end
