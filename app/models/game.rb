class Game < ActiveRecord::Base
  include ActiveModel::Validations

  # game type
  SMALL = 'small'
  STANDARD = 'standard'
  LARGE = 'large'

  # status
  PENDING = 'pending'
  SETUP = 'setup'
  IN_PROGRESS = 'in progress'
  FINISHED = 'finished'

  validate :_has_owner
  validate :_has_opponent
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
    inverse_of: :games
  )

  def randomize_starting_player
    @current_attacker_id = [@owner_id, @opponent_id].sample
  end

  private
  def _has_opponent
    if opponent.nil? && User.find_by_id(opponent_id).nil?
      errors.add(:opponent, "can't be blank")
    end
  end

  def _has_owner
    if owner.nil? && User.find_by_id(owner_id).nil?
      errors.add(:owner, "can't be blank")
    end
  end
end
