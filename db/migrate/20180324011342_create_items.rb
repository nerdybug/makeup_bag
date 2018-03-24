class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
    	t.string :name
    	t.integer :user_id
    	t.integer :brand_id
    	t.boolean :favorite
    	t.boolean :need_more
    end
  end
end
