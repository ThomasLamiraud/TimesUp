class Game < ApplicationRecord
  belongs_to :user

  has_many :words
  has_many :game_players
  has_many :users, through: :game_players

  before_create :set_slug, :set_state, :set_round

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

  enum round: {
    turn_1: 0,
    turn_2: 1,
    turn_3: 2
  }

  TIMER_VALUES = {
    turn_1: 30,
    turn_2: 45,
    turn_3: 60
  }

  def display_round
    case round
    when "turn_1"
      "turn 1"
    when "turn_2"
      "turn 2"
    when "turn_3"
      "turn 3"
    end
  end

  private

  def set_slug
    return unless new_record?

    self.slug = SecureRandom.uuid
  end

  def set_state
    return unless state.nil?

    self.state = :started
  end

  def set_round
    return unless round.nil?

    self.round = :turn_1
  end
end
