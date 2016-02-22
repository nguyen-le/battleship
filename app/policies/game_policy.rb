class GamePolicy
  def initialize(game)
    @game = game
  end

  def can_create_more_ships?(user)
    Ship.where(game_id: @game.id, user_id: user.id).count <= ships_allowed
  end

  def can_start_game?
    @game.status == Game::SETUP &&
      (Ship.where(game_id: @game.id, user_id: [@game.owner_id, @game.opponent_id]).count ==
        (ships_allowed * 2))
  end

  def game_boundaries
    a_z = ('a'..'z').to_a
    @game_boundaries ||=
      case @game.game_type
      when Game::SMALL
        {alphabet: a_z[0..6], number: 6}
      when Game::STANDARD
        {alphabet: a_z[0..10], number: 10}
      when Game::LARGE
        {alphabet: a_z[0..20], number: 20}
      end
  end

  def is_setup_phase?
    @game.status == Game::SETUP
  end

  def location_within_bounds?(square)
    c, within_letter_bounds = letter_col_within_bounds(square)
    n, within_num_bounds = num_row_within_bounds(square)
    within_letter_bounds && within_num_bounds
  end

  def letter_col_within_bounds(square)
    row_letter = square.downcase.match(/[a-z]+/).to_s
    within_bounds = game_boundaries[:alphabet].include?(row_letter)
    [row_letter, within_bounds]
  end

  def num_row_within_bounds(square)
    row_num = square.match(/\d+/).to_s.to_i
    within_bounds = row_num.between?(1, game_boundaries[:number])
    [row_num, within_bounds]
  end

  def ships_allowed
    case @game.game_type
    when Game::SMALL
      2
    when Game::STANDARD
      5
    when Game::LARGE
      10
    end
  end
end
