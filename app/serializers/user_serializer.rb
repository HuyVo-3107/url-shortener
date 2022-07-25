class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :api_token_private
end
