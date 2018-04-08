class RemoveBrandFavorite < ActiveRecord::Migration[5.1]
  def change
    remove_column :brands, :favorite, :boolean
  end
end
