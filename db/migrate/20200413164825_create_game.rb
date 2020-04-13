class CreateGame < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.string :slug
      t.integer :state
      t.integer :round
      t.integer :player_count
      t.integer :word_count
      t.integer :user_id
      t.timestamps
    end
  end
end
