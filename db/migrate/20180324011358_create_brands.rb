class CreateBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :brands do |t|
    	t.string :name
    	t.boolean :favorite
    end
  end
end
