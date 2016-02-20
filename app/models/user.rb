class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :games,
    foreign_key: 'owner_id',  inverse_of: :owner, dependent: :destroy
end
