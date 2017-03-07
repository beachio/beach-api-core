module BeachApiCore
  class UserSimpleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :email, :username, :first_name, :last_name
  end
end
