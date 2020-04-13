class Game < ApplicationRecord
  belongs_to :user

  before_save :set_slug, :set_state

  validates :player_count, :player_count, numericality: { only_integer: true }

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

    slef.state = state[:started]
  end
end
