class Shot < ActiveRecord::Base
  validates :location, uniqueness: { scope: [:game_id, :user_id, :location] }
  validates_presence_of :game
  validates_presence_of :user
  validates_presence_of :receiving_player

  belongs_to :game, inverse_of: :shots, dependent: :destroy
  belongs_to :user, inverse_of: :shots, dependent: :destroy
  belongs_to(
    :receiving_player,
    class_name: 'User',
    foreign_key: 'receiving_player_id',
    dependent: :destroy,
    inverse_of: :shots
  )
end
