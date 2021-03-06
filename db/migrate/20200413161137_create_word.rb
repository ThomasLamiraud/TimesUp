class CreateWord < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :word
      t.integer :user_id
      t.integer :game_id
      t.integer :used_count
      t.boolean :hide
      t.timestamps
    end
  end
end
