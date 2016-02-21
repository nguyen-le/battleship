class GameSerializer < ActiveModel::Serializer
  attributes :id, :status, :owner_id, :opponent_id
  has_one :owner
  has_one :opponent
end
