class AddLastfmUrlToBand < ActiveRecord::Migration
  def change
    add_column :bands, :lastfm_url, :string
  end
end
