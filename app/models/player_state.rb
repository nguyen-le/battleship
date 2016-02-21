class PlayerState < ActiveRecord::Base
  belongs_to :game, autosave: true, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
