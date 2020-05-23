# Class to handle find and gather some data for Game
class GameManager
  def initialize(slug:)
    @slug = slug
  end

  def game
    @game ||= begin
      Game
      .includes(:user)
      .joins(:user)
      .includes(:users)
      .left_joins(:users)
      .includes(:words)
      .left_joins(:words)
      .find_by(slug: @slug)
    end
  end

  def restart_game
    game.update(state: :started, round: :turn_1,)
    game.words.update_all(hide: false,
                          user_id_turn_1: nil,
                          user_id_turn_2: nil,
                          user_id_turn_3: nil)
  end

  def turns_data
    turns_data = []

    game.users.map do |player|
      turn_data_hash = {}
      turn_data_hash[:player] = player
      turn_data_hash[:score_turn_1] = game.words.where(user_id_turn_1: player.id).count
      turn_data_hash[:score_turn_2] = game.words.where(user_id_turn_2: player.id).count
      turn_data_hash[:score_turn_3] = game.words.where(user_id_turn_3: player.id).count
      turn_data_hash[:total_score] = turn_data_hash[:score_turn_1] + turn_data_hash[:score_turn_2] + turn_data_hash[:score_turn_3]
      turns_data << turn_data_hash
    end

    turns_data.sort_by! { |hsh| hsh[:total_score] }.reverse!
  end

  def update_turn
    case game.round
    when "turn_1"
      game.round = "turn_2"
    when "turn_2"
      game.round = "turn_3"
    when "turn_3"
      game.state = "finished"
    end
    game.save
  end
end
