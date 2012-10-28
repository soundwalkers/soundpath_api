class ChangePicUrlColumn < ActiveRecord::Migration
  def up
    change_column :bands, :pic_url, :text
  end

  def down
    change_column :bands, :pic_url, :string
  end
end
