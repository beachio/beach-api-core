module BeachApiCore
  class UserSimpleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :email, :username, :first_name, :last_name
  end
end
