class Game < ApplicationRecord
  belongs_to :user

  has_many :words
  has_many :game_players
  has_many :users, through: :game_players

  before_save :set_slug, :set_state

  validates :player_count, :player_count, numericality: { only_integer: true }

  accepts_nested_attributes_for :words,
    allow_destroy: true,
    reject_if: :blank?

  accepts_nested_attributes_for :game_players,
    allow_destroy: true,
    reject_if: :blank?

  enum state: {
    started: 0,
    ongoing: 1,
    pause: 2,
    finished: 3
  }
  private

  def set_slug
    return unless new_record?

    self.slug = SecureRandom.uuid
  end

  def set_state
    return unless state.nil?

    self.state = :started
  end
end
