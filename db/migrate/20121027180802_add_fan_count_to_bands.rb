class AddFanCountToBands < ActiveRecord::Migration
  def change
    add_column :bands, :fan_count, :integer
  end
end
