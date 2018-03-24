class AddDefaultToItemNeedMore < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :need_more, :boolean, :default => false
  end
end
