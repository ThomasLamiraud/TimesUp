class User < ApplicationRecord
  has_many :words
  has_many :game_players
  has_many :games, through: :game_players

  validates :name, presence: true, uniqueness: true
end
