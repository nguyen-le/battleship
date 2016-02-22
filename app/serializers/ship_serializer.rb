class ShipSerializer < ActiveModel::Serializer
  attributes :id, :ship_type, :health, :location, :game_id, :user_id
end
