class AddDefaultToItemFavorite < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :favorite, :boolean, :default => false
  end
end
