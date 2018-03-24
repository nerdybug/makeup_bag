class AddDefaultToBrandFavorite < ActiveRecord::Migration[5.1]
  def change
    change_column :brands, :favorite, :boolean, :default => false
  end
end
