class Game < ActiveRecord::Base
  include ActiveModel::Validations

  PENDING = 'PENDING'
  SETUP = 'SETUP'
  IN_PROGRESS = 'IN_PROGRESS'
  FINISHED = 'FINISHED'

  validate :_has_owner
  validate :_has_opponent
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

  private
  def _has_opponent
    if opponent.nil? && opponent_id.nil?
      errors.add(:opponent, "can't be blank")
    end
  end

  def _has_owner
    if owner.nil? && owner_id.nil?
      errors.add(:owner, "can't be blank")
    end
  end
end
