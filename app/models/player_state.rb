class PlayerState < ActiveRecord::Base
  belongs_to :game, autosave: true, dependent: :destroy, inverse_of: :player_states
  belongs_to :user, autosave: true, dependent: :destroy, inverse_of: :player_states

  validates :user_id, uniqueness: { scope: [:game_id] }
end
