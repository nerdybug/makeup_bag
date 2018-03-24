class ChangeTypeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :type, :type_of_item
  end
end
