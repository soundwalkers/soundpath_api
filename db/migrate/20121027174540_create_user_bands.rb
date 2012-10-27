class CreateUserBands < ActiveRecord::Migration
  def up
    create_table :user_bands do |t|
      t.integer :user_id
      t.integer :band_id
    end
  end

  def down
    drop_table :user_bands
  end
end
