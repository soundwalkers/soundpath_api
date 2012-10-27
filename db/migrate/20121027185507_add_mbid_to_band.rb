class AddMbidToBand < ActiveRecord::Migration
  def change
    add_column :bands, :mbid, :string
  end
end
