module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username
    has_one :profile
  end
end