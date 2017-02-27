module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username, :status
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_many :assignments
  end
end
