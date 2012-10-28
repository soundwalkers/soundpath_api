class AddTimestamps < ActiveRecord::Migration
  def up
    add_column :bands, :created_at, :datetime
    add_column :bands, :updated_at, :datetime

    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime

    add_column :user_bands, :created_at, :datetime
    add_column :user_bands, :updated_at, :datetime
  end

  def down
    remove_column :bands, :created_at
    remove_column :bands, :updated_at

    remove_column :users, :created_at
    remove_column :users, :updated_at

    remove_column :user_bands, :created_at
    remove_column :user_bands, :updated_at
  end
end
