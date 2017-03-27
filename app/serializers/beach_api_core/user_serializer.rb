module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :username
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_one :organisations
  end
end
