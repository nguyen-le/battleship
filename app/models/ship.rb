class Ship < ActiveRecord::Base
  # ship types
  DESTROYER = 'destroyer'
  CRUISER = 'cruiser'
  SUBMARINE = 'submarine'
  BATTLESHIP = 'battleship'
  CARRIER = 'carrier'

  validates :ship_type,
    inclusion: { in: [DESTROYER, CRUISER, SUBMARINE, BATTLESHIP, CARRIER] },
    uniqueness: { scope: [:game_id, :user_id, :ship_type] }
  validates_presence_of :user
  validates_presence_of :game

  belongs_to :user, inverse_of: :ships
  belongs_to :game, inverse_of: :ships

  before_save :calc_health

  def calc_health
    self.health = self.location.inject(0) { |sum, (square, hp)| sum + hp }
  end
end
