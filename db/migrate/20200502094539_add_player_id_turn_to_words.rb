class AddPlayerIdTurnToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :user_id_turn_1, :integer
    add_column :words, :user_id_turn_2, :integer
    add_column :words, :user_id_turn_3, :integer
  end
end
