class CreateItemBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :item_brands do |t|
    	t.integer :item_id
    	t.integer :brand_id
    end
  end
end
