module BeachApiCore
  class UserSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :email, :username
    has_one :profile, serializer: BeachApiCore::ProfileSerializer
    has_many :organisations
  end
end
