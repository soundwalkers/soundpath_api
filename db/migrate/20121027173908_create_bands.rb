class CreateBands < ActiveRecord::Migration
  def up
    create_table :bands do |t|
      t.string    :name
      t.string    :page_id
      t.string    :plays
      t.string    :listeners
      t.string    :pic_url
    end
  end

  def down
    drop_table :bands
  end
end
