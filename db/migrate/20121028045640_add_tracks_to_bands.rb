class AddTracksToBands < ActiveRecord::Migration
  def change
    add_column :bands, :tracks, :text
  end
end
