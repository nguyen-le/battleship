class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :games,
    foreign_key: 'owner_id',  inverse_of: :owner, dependent: :destroy, autosave: true
  has_many :player_states, inverse_of: :user, autosave: true
  has_many :ships, autosave: true, inverse_of: :user
  has_many :shots, inverse_of: :user, autosave: true
end
