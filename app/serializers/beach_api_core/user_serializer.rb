module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
  end
end