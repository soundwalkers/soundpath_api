class AddScoreToBands < ActiveRecord::Migration
  def change
    add_column :bands, :score, :float
  end
end
