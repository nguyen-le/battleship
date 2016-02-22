class Ship < ActiveRecord::Base
  # ship types
  DESTROYER = 'destroyer'
  CRUISER = 'cruiser'
  SUBMARINE = 'submarine'
  BATTLESHIP = 'battleship'
  CARRIER = 'carrier'

  validates :ship_type,
    inclusion: { in: [DESTROYER, CRUISER, SUBMARINE, BATTLESHIP, CARRIER] },
    uniqueness: { scope: [:game_id, :user_id] }
  validates_presence_of :user
  validates_presence_of :game

  belongs_to :user, inverse_of: :ships
  belongs_to :game, inverse_of: :ships

  before_save :calc_health

  def self.get_size(ship_type)
    case ship_type
    when Ship::DESTROYER
      2
    when Ship::CRUISER
      3
    when Ship::SUBMARINE
      3
    when Ship::BATTLESHIP
      4
    when Ship::CARRIER
      5
    end
  end

  def calc_health
    self.health = self.location.inject(0) { |sum, (square, hp)| sum + hp }
  end
end
