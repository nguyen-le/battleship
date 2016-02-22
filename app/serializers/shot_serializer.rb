class ShotSerializer < ActiveModel::Serializer
  attributes :id, :location, :game_id, :user_id, :receiving_player_id
end
