class Item < ActiveRecord::Base
  belongs_to :user

  has_many :item_brands
  has_many :brands, through: :item_brands
end
