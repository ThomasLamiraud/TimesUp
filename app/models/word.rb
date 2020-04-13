class Word < ApplicationRecord
  belongs_to :user
  validates :word, presence: true, uniqueness: true
end
