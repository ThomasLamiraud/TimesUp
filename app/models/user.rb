class User < ApplicationRecord
  has_many :words
  has_many :games
  validates :name, presence: true, uniqueness: true
end
