class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name

  def self.collection(user_collection)
    if user_collection
      user_collection.map { |user| {id: user.id, user_name: user.user_name} }
    else
      []
    end
  end
end
