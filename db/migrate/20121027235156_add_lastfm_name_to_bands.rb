class AddLastfmNameToBands < ActiveRecord::Migration
  def change
    add_column :bands, :lastfm_name, :string
  end
end
