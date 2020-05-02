class Word < ApplicationRecord
  belongs_to :user
  validates :word, presence: true

  scope :not_available, -> { where(hide: true) }
  scope :available, -> { where(hide: false) }
end
