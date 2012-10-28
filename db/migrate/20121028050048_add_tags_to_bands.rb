class AddTagsToBands < ActiveRecord::Migration
  def change
    add_column :bands, :tags, :text
  end
end
