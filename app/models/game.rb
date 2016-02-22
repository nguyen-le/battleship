class Game < ActiveRecord::Base
  include ActiveModel::Validations

  # game type
  SMALL = 'small'
  STANDARD = 'standard'
  LARGE = 'large'

  # health
  SMALL_HP = 6
  STANDARD_HP = 17
  LARGE_HP = 34

  # status
  PENDING = 'pending'
  SETUP = 'setup'
  IN_PROGRESS = 'in progress'
  FINISHED = 'finished'

  validates_presence_of :owner
  validates_presence_of :opponent
  validates :game_type, inclusion: {in: [SMALL, STANDARD, LARGE]}
  validates :status, inclusion: {in: [PENDING, SETUP, IN_PROGRESS, FINISHED]}

  belongs_to(
    :owner,
    class_name: 'User',
    foreign_key: 'owner_id',
    inverse_of: :games,
    dependent: :destroy
  )
  belongs_to(
    :opponent,
    class_name: 'User',
    foreign_key: 'opponent_id',
    inverse_of: :games,
    dependent: :destroy
  )
  has_many :player_states, inverse_of: :game
  has_many :ships, inverse_of: :game
  has_many :shots, inverse_of: :game

  def self.create_grid(size)
    n =
      case size
      when Game::SMALL
        6
      when Game::STANDARD
        10
      when Game::LARGE
        20
      end
    grid = {}
    ('a'..'z').to_a.each_with_index do |letter, idx|
      break if idx == n
      grid[letter] = Array.new(n) { 0 }
    end
    return grid
  end
end
