class Brand < ActiveRecord::Base
  has_many :users, through: :items
  has_many :items, through: :item_brands
  has_many :item_brands
end
