class Game < ActiveRecord::Base
  PENDING = 'PENDING'
  SETUP = 'SETUP'
  IN_PROGRESS = 'IN_PROGRESS'
  FINISHED = 'FINISHED'

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
  )
end
