class User < ActiveRecord::Base
  has_secure_password
  has_many :items
  has_many :brands, through: :items
end
