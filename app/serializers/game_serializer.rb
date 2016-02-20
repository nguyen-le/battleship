class GameSerializer < ActiveModel::Serializer
  attributes :id, :status
  has_one :owner
  has_one :opponent
end
