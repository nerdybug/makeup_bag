class AddTypeToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :type, :string
  end
end
